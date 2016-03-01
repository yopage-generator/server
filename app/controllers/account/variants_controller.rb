class Account::VariantsController < Landing::BaseController
  layout 'landing'

  def update
    variant.update_attributes! permitted_params
    redirect_to account_variants_path(current_landing)
  rescue ActiveRecord::RecordInvalid => err
    render 'edit', locals: { variant: err.record }
  end

  def edit
    render locals: { variant: variant }
  end

  def new
    render locals: { variant: build_variant }
  end

  def create
    variant = build_variant
    variant.assign_attributes permitted_params
    variant.save!
    redirect_to account_variants_path(current_landing)
  rescue ActiveRecord::RecordInvalid => err
    render 'edit', locals: { variant: err.record }
  end

  def index
    render locals: { variants: variants }
  end

  private

  def build_variant
    current_landing.variants.build
  end

  def variants
    current_landing.variants.ordered
  end

  def variant
    @_variant ||= current_landing.variants.find params[:id]
  end

  def permitted_params
    params.require(:variant).permit(:title)
  end
end
