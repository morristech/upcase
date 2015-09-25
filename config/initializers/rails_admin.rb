RailsAdmin.config do |config|
  config.authenticate_with do
    unless current_user
      session[:return_to] = request.url
      redirect_to "/sign_in", :alert => "You must first log in or sign up before accessing this page."
    end
  end

  config.authorize_with do
    redirect_to "/", :alert => "You are not authorized to access that page" unless current_user.admin?
  end

  config.current_user_method { current_user }

  config.main_app_name = ['Upcase', 'Admin']

  config.yell_for_non_accessible_fields = false

  config.actions do
    init_actions!
  end

  config.model User do
    list do
      field :id
      field :name
      field :email
      field :github_username
      field :subscription
      field :masquerade do
        pretty_value do
          bindings[:view].link_to(
            'Masquerade',
            bindings[:view].main_app.user_masquerade_path(bindings[:object]),
            method: :post
          )
        end
      end
    end

    edit do
      field :email
      field :name
      field :admin
      field :bio
      field :github_username
      field :stripe_customer_id
    end
  end

  config.model Product do
    list do
      field :id
      field :name
      field :sku
      field :type

      sort_by :name
    end
  end

  config.model Exercise do
    list do
      field :id
      field :name
    end

    edit do
      field :whetstone_edit_url do
        label false
        help false
        partial "whetstone_edit_url"
      end

      field :trail
    end
  end

  config.model Trail do
    list do
      field :id
      field :name
      field :published
    end

    edit do
      include_all_fields

      field :steps do
        orderable true
      end

      exclude_fields :exercises, :videos, :statuses, :users
     end
   end

  config.model Video do
    list do
      field :id

      field :watchable do
        label "Product name"

        pretty_value do
          value.name
        end
      end

      field :name
      field :created_at
    end

    edit do
      group :default do
        field :name
        field :slug
        field :summary
        field :notes
        field :topics

        field :watchable do
          partial "form_watchable_association"
        end

        field :position
        field :published_on
        field :users
        field :length_in_minutes
        field :markers
      end

      group :wistia do
        field :wistia_id
        field :preview_wistia_id
      end
    end
  end

  config.model Marker do
    field :video
    field :anchor
    field :time do
      label "Time (seconds)"
    end
  end
end
