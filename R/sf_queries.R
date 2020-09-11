#' Make common soql queries from Salesforce
#'
#' @param cohorts Designations of the cohorts of fellows to query.
#' Accepts 'current', 'all', or a numeric vector.
#'
#' Queries the City Forward Collective Salesforce Instance with
#' common soql queries.
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

      soql <- sprintf("SELECT Id, Cohort__r.Name, Contact__r.FirstName, Contact__r.LastName, Contact__r.Email,
                    Contact__r.Title, Contact__r.Current_Employer__c FROM Leader__c WHERE Cohort__c in ('%s')",
                      paste0(cos$Id, collapse = "','"))

      burkes <- sf_query(soql, object_name = "Leader__c")

      current_burkes <<- burkes %>%
        transmute(first_name = Contact__r.FirstName,
                  last_name = Contact__r.LastName,
                  full_name = paste(first_name, last_name),
                  email = Contact__r.Email,
                  title = Contact__r.Title,
                  current_employer = Contact__r.Current_Employer__c,
                  cohort = Cohort__r.Name,
                  leader_id = Id)

    } else if (cohorts == "all") {

      soql <- sprintf("SELECT Id, Cohort__r.Name, Contact__r.FirstName, Contact__r.LastName, Contact__r.Email,
                    Contact__r.Title, Contact__r.Current_Employer__c FROM Leader__c WHERE Cohort__c in ('%s')",
                      paste0(sf_cohorts$Id, collapse = "','"))

      burkes <- sf_query(soql, object_name = "Leader__c")

      all_burkes <<- burkes %>%
        transmute(first_name = Contact__r.FirstName,
                  last_name = Contact__r.LastName,
                  full_name = paste(first_name, last_name),
                  email = Contact__r.Email,
                  title = Contact__r.Title,
                  current_employer = Contact__r.Current_Employer__c,
                  cohort = Cohort__r.Name,
                  leader_id = Id)
    } else {

      stop("The 'cohorts' argument must either be 'current', 'all', or a numberic vector.")

    }


  } else if (is.numeric(cohorts)) {

    cos <- sf_cohorts %>%
      filter(number %in% cohorts)

    soql <- sprintf("SELECT Id, Cohort__r.Name, Contact__r.FirstName, Contact__r.LastName, Contact__r.Email,
                    Contact__r.Title, Contact__r.Current_Employer__c FROM Leader__c WHERE Cohort__c in ('%s')",
                    paste0(cos$Id, collapse = "','"))

    burkes <- sf_query(soql, object_name = "Leader__c")

    burkes <<- burkes %>%
      transmute(first_name = Contact__r.FirstName,
                last_name = Contact__r.LastName,
                full_name = paste(first_name, last_name),
                email = Contact__r.Email,
                title = Contact__r.Title,
                current_employer = Contact__r.Current_Employer__c,
                cohort = Cohort__r.Name,
                leader_id = Id)

  } else {

    stop("The 'cohorts' argument must either be 'current', 'all', or a numberic vector.")

  }

}

