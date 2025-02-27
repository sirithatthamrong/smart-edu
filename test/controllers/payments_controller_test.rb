require "test_helper"
require 'stripe'

class PaymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    # Set Stripe's test secret key for the test environment
    Stripe.api_key = 'sk_test_4eC39HqLyjWDarjtT1zdp7dc'  # Use your actual test key
  end

  test "should create payment" do
    # Create a test card token using Stripe's API (this is for testing purposes only)
    token = Stripe::Token.create({
                                   card: {
                                     number: '4242424242424242', # Test card number (this is valid for testing)
                                     exp_month: 12,
                                     exp_year: 2025,
                                     cvc: '123',
                                   }
                                 })

    # Simulate a payment request to your controller
    post new_pay, params: {
      first_name: 'John',
      last_name: 'Doe',
      amount: 10,  # Amount in THB (10 THB)
      payment_method_id: token.id  # Using the token for the payment method
    }

    # Assert that the response is a success
    assert_response :success

    # Ensure the payment was created in the database with the correct details
    payment = Payment.last
    assert_equal 'successful', payment.status
    assert_equal 10, payment.amount
    assert_equal 'thb', payment.currency
    assert_not_nil payment.stripe_payment_intent_id  # Check if the intent id was saved
  end

  test "should handle stripe error" do
    # Simulate a failed payment using an invalid card number
    token = Stripe::Token.create({
                                   card: {
                                     number: '4000000000000002', # Invalid test card number
                                     exp_month: 12,
                                     exp_year: 2025,
                                     cvc: '123',
                                   }
                                 })

    post create_payments_url, params: {
      first_name: 'John',
      last_name: 'Doe',
      amount: 10,
      payment_method_id: token.id
    }

    # Assert that the response indicates an error
    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert_includes json_response['error'], 'Your card was declined'
  end
end
