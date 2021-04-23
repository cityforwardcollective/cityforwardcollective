#' Retrieve list of Burke Fellows from City Forward Collective's Salesforce instance
#'
#' @param cohorts Designations of the cohorts of fellows to query.
#' Accepts 'current', 'all', or a numeric vector.
#'
#'
#' @import salesforcer
#' @importFrom magrittr %>%
#' @import dplyr
#' @import tidyr
#' @import stringr
#'
#' @export get_burke_fellows

get_burke_fellows <- function(cohorts = "current") {

  # First get Alverno Cohorts

  sf_cohorts <- sf_query("SELECT Id, Name FROM Cohort__c WHERE Name like 'Alverno%'", object_name = "Cohort__c") %>%
    mutate(number = as.numeric(str_extract(Name, "\\d{1,2}$"))) %>%
    arrange(number)

  # Default case: pull current fellows

  if (is.character(cohorts)) {

    if (cohorts == "current") {

      cos <- sf_cohorts %>%
        filter(number >= max(number) - 1)

      soql <- sprintf("SELECT Id, Contact__r.Id, Cohort__r.Name, Contact__r.FirstName, Contact__r.LastName, Contact__r.Email,
                    Contact__r.Title, Contact__r.Current_Employer__c, Age_Upon_Entry__c, Race_Ethnicity__c, Pronouns__c
                      FROM Leader__c WHERE Cohort__c in ('%s')",
                      paste0(cos$Id, collapse = "','"))

      burkes <- sf_query(soql, object_name = "Leader__c")

      current_burkes <- burkes %>%
        transmute(first_name = Contact__r.FirstName,
                  last_name = Contact__r.LastName,
                  full_name = paste(first_name, last_name),
                  email = Contact__r.Email,
                  title = Contact__r.Title,
                  current_employer = Contact__r.Current_Employer__c,
                  cohort = Cohort__r.Name,
                  age_upon_entry = Age_Upon_Entry__c,
                  race_ethnicity = Race_Ethnicity__c,
                  pronouns = Pronouns__c,
                  leader_id = Id,
                  contact_id = Contact__r.Id)

      return(current_burkes)

    } else if (cohorts == "all") {

      soql <- sprintf("SELECT Id, Contact__r. Id, Cohort__r.Name, Contact__r.FirstName, Contact__r.LastName, Contact__r.Email,
                    Contact__r.Title, Contact__r.Current_Employer__c, Age_Upon_Entry__c, Race_Ethnicity__c, Pronouns__c
                       FROM Leader__c WHERE Cohort__c in ('%s')",
                      paste0(sf_cohorts$Id, collapse = "','"))

      burkes <- sf_query(soql, object_name = "Leader__c")

      all_burkes <- burkes %>%
        transmute(first_name = Contact__r.FirstName,
                  last_name = Contact__r.LastName,
                  full_name = paste(first_name, last_name),
                  email = Contact__r.Email,
                  title = Contact__r.Title,
                  current_employer = Contact__r.Current_Employer__c,
                  cohort = Cohort__r.Name,
                  age_upon_entry = Age_Upon_Entry__c,
                  race_ethnicity = Race_Ethnicity__c,
                  pronouns = Pronouns__c,
                  leader_id = Id,
                  contact_id = Contact__r.Id)

      return(all_burkes)

    } else {

      stop("The 'cohorts' argument must either be 'current', 'all', or a numberic vector.")

    }


  } else if (is.numeric(cohorts)) {

    cos <- sf_cohorts %>%
      filter(number %in% cohorts)

    soql <- sprintf("SELECT Id, Contact__r. Id, Cohort__r.Name, Contact__r.FirstName, Contact__r.LastName, Contact__r.Email,
                    Contact__r.Title, Contact__r.Current_Employer__c, Age_Upon_Entry__c, Race_Ethnicity__c, Pronouns__c
                       FROM Leader__c WHERE Cohort__c in ('%s')",
                    paste0(cos$Id, collapse = "','"))

    burkes <- sf_query(soql, object_name = "Leader__c")

    burkes <- burkes %>%
      transmute(first_name = Contact__r.FirstName,
                last_name = Contact__r.LastName,
                full_name = paste(first_name, last_name),
                email = Contact__r.Email,
                title = Contact__r.Title,
                current_employer = Contact__r.Current_Employer__c,
                cohort = Cohort__r.Name,
                age_upon_entry = Age_Upon_Entry__c,
                race_ethnicity = Race_Ethnicity__c,
                pronouns = Pronouns__c,
                leader_id = Id,
                contact_id = Contact__r.Id)

    return(burkes)

  } else {

    stop("The 'cohorts' argument must either be 'current', 'all', or a numberic vector.")

  }

}


# School Leaders ==========

