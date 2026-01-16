Rails.application.config.session_store :cookie_store,
                                       key: "_finalist_session",
                                       expire_after: 365.days,
                                       same_site: :lax,
                                       secure: Rails.env.production?,
                                       httponly: true
