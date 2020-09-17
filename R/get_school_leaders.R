#' Retrieve list of School Leaders from City Forward Collective's Salesforce instance
#'
#' @import salesforcer
#' @importFrom magrittr %>%
#' @import dplyr
#' @import tidyr
#' @import stringr
#'
#' @export get_school_leaders

get_school_leaders <- function() {

  soql <- sprintf("SELECT Id, Name, DPI_Name__c, npe01__One2OneContact__c, npe01__One2OneContact__r.Name,
                  Primary_Contact_Email__c FROM Account
                  WHERE Type = 'School' AND School_is_Closed__c = false AND DPI_Name__c != null")

  temp <- sf_query(soql, object_name = "Account")

  school_primary_contacts <- temp %>%
    select(account_id = Id,
           contact_id = npe01__One2OneContact__c,
           dpi_true_id = DPI_Name__c,
           school_name = Name,
           primary_contact = npe01__One2OneContact__r.Name,
           first_name = npe01__One2OneContact__r.FirstName,
           last_name = npe01__One2OneContact__r.LastName,
           primary_contact_email = Primary_Contact_Email__c)

  return(school_primary_contacts)
}
