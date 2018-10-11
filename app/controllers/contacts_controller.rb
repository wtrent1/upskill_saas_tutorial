class ContactsController < ApplicationController

  # GET request to /contact-us
  # Show new contact form
  def new
    @contact = Contact.new
  end
  
  # OST request to /contacts
  def create
    # Mass assignment of form fields into contact object
    @contact = Contact.new(contact_params)
    if @contact.save
      # Store form fields via parameters, into variables
      name = params[:contact][:name]
      email = params[:contact][:email]
      body = params[:contact][:comments]
      # Plug variables into contact mailer
      # Email method and send email
      ContactMailer.contact_email(name, email, body).deliver
      # Store success message in flash hash
      # and redirect to the new action
      flash[:success] = "Message sent."
      redirect_to new_contact_path
    else
      # If Contact object doesn't save, store errors in flash hash and
      # redirect to the new action
      flash[:danger] = @contact.errors.full_messages.join(", ")
      redirect_to new_contact_path
    end
  end
  
  private
  # To collect data from form,strong parameters were used and form fields were
  # whitelisted
    def contact_params
      params.require(:contact).permit(:name, :email, :comments)
    end
end