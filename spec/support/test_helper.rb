include ApplicationHelper
include SessionsHelper
include ConstructionsHelper
include OrdersHelper
include EventsHelper

def sign_in_as(user)
  post login_path, params: { session: { email: user.email,
                                        password: user.password } }
end
