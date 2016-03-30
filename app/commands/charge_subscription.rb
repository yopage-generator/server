class ChargeSubscription
  include Virtus.model(strict: true, nullify_blank: true)

  attribute :account, Account
  attribute :tariff, Tariff
  attribute :month, Date

  def call
    return if negative_fee?

    Openbill.current.make_transaction(
      from: account.billing_account,
      to: SystemRegistry[:subscriptions],
      key: "subscription-#{account.id}-#{month}",
      amount: fee.total,
      details: fee.description,
      meta: { 
        gateway: :cloudpayments,
        month: month,
        tariff_id: tariff.id
        }
    )
  rescue => err
    Bugsnag.notify err, metaData: { fee: fee, account: account, tariff: tariff, month: month }
  end

  private

  def negative_fee?
    fee.total <= Money.new(0, :rub)
  end

  def fee
    @_fee ||= fee_strategy.new(account: account, tariff: tariff, month: month).call
  end

  def fee_strategy
    case tariff.slug
    when Tariff::BASE_SLUG
      PerLandingFeeStrategy
    end
  end
end