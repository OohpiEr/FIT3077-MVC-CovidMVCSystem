require_relative 'customer'
require_relative 'receptionist'
require_relative 'healthcare_worker'

#
# User Factory Class
#
class UserFactory

    #
    # Getter for user 
    #
    # @param [hash] userData 
    #
    # @return [User] user child classes Customer, Receptionist or HealthcareWorker
    #
    def self.getUser(userData)
        if userData[:isCustomer]
            return Customer.new(userData[:id], userData[:givenName], userData[:familyName], userData[:userName], userData[:phoneNumber], userData[:bookings], userData[:additionalInfo], userData[:testsTaken])
        elsif userData[:isReceptionist]
            return Receptionist.new(userData[:id], userData[:givenName], userData[:familyName], userData[:userName], userData[:phoneNumber], userData[:additionalInfo])
        elsif userData[:isHealthcareWorker]
            return HealthcareWorker.new(userData[:id], userData[:givenName], userData[:familyName], userData[:userName], userData[:phoneNumber], userData[:additionalInfo], userData[:testsAdministered])
        end
    end

end