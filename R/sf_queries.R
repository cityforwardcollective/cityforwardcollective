# Define common soql queries

soql_basic_contact_info <- sprintf("SELECT Id,
                                   FirstName,
                                   LastName,
                                   Title,
                                   Current_Employer__c,
                                   npe01__HomeEmail__c,
                                   npe01__WorkEmail__c,
                                   npe01__Preferred_Email__c FROM Contact")
