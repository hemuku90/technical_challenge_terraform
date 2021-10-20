
# Koodoo Platform Engineer Technical Assessment 👾

---

## Introduction 🎬

First of all, congrats 🥳. We've enjoyed our initial chat and are pleased that you've decided to consider joining the Koodoo engineering team!

As a way to introduce you to our way of building software we've put together a (small) technical challenge for you to complete before the next stage of the process.

## Assumptions and requirements ✅

As a platform engineer 🏗, you'll hopefully be familiar with:

* Cloud Providers like GCP and AWS as well as some of their offerings.

* Infrastructure scripting languages and tools, such as Terraform or Bash.

* Continuous integration solutions such as CircleCI or Jenkins.

* A solid understanding of cloud networking solutions. 

* General solid software fundamentals 💪

In order to complete this assignment, all you should need is any machine that can execute Terraform.

## The challenge 💻

**Background**:

Consider the following service configuration denoted by this JSON data structure.

```
service_configuration = [
  {
    serviceName     = "possums-data-store"
    mongoCluster    = "animals-mongo"
    mongoDatabase   = "marsupials-dev"
    mongoCollection = ["possums"]
  },
  {
    serviceName     = "numbats-data-store"
    mongoCluster    = "animals-mongo"
    mongoDatabase   = "marsupials-dev"
    mongoCollection = ["numbats"]
  }
]
```

This represents a collection of application services and their connections to specific mongoDB collections.

In the example above, we have two application services:

- `numbats-data-store`
and
- `possums-data-store`

which both connect to a mongo cluster:

- `animals-mongo`

and each have a connection to one of the following mongo collections:

- `marsupials-dev.possums`
- `marsupials-dev.numbats`

(Read [this](https://docs.mongodb.com/manual/core/databases-and-collections/) glossary for mongo specific terminology if this is not something you're too familiar with)

![tech-test-plat](https://user-images.githubusercontent.com/78343680/117894459-48319b00-b2b4-11eb-9ef2-1b31c4c6ee13.png)


### Your Task

Put together a terraform script/module which produces the correct database configuration required for the applications to securely connect to the mongo db database depicted above. 

Here's a *very* rough sketch of what this might look like (not functional code, just for demo purposes!)

```
data mongodbatlas_clusters this {
  project_id = var.mongdbatlas_project_id
}

data mongodbatlas_cluster this {
  for_each = toset(data.mongodbatlas_clusters.this.results[*].name)

  project_id = var.mongdbatlas_project_id
  name       = each.value
}

  connection_strings = {
    for svc in var.service_configuration :
    # your code magic here to construct the correct connection string based on the following convention mongodb+srv://[username]:[password]@[cluster]/[db]/[collection]
  }
}


resource random_password store-service-password {
  # Generate a unique new password for the DB user
}

resource mongodbatlas_database_user store-service-user {
  # create a username for the service (e.g. the service name)
  username           = "${var.environment}-${each.key}" 
  # create a password for the service 
  password           = random_password.store-service-password
  # Create the right role (read only permissions) for this user and service
  dynamic roles {
    for_each = each.value.mongoCollection[*]
    content {
      role_name       = "read"
      database_name   = each.value.mongoDatabase
      collection_name = roles.value
    }
  }
}
```

In other words, write a Terraform script or module(s) that takes in a generic service config json document as input (formatted like the one above) and correctly outputs the required db config for each service defined.

Specifically:

- For each service entry in the service config JSON
- The terraform module automatically generates a correctly formatted db connection uri in the following convention:

`mongodb+srv://[username]:[password]@[cluster]/[db]/[collection]`

- The password is unique for each service
- The username is the service's name
- Each of these services should have read only access to the required collections. 

For example, in our above define case of the possum-data-store service, we would produce the following uri:

- `mongodb+srv://possums-data-store:fGd345dFhjk@animals-mongo/marsupials-dev/possums`

Use this example as a base case to test your solution with.

```
service_configuration = [
  {
    serviceName     = "possums-data-store"
    mongoCluster    = "animals-mongo"
    mongoDatabase   = "marsupials-dev"
    mongoCollection = ["possums"]
  },
  {
    serviceName     = "numbats-data-store"
    mongoCluster    = "animals-mongo"
    mongoDatabase   = "marsupials-dev"
    mongoCollection = ["numbats"]
  },
   {
    serviceName     = "marsupial-data-store"
    mongoCluster    = "animals-mongo"
    mongoDatabase   = "marsupials-prod"
    mongoCollection = ["numbats","possums"]
  },
]
```

### Things to consider in your solution 🤔

- Does it solve/run for the basic case?
- Does the uri have any special character requirements?
- Password complexity
- How might you test this?

We're not looking for a 100% full proof solution (which might not exist anyway depending on the use case).

* ‼️ Please do not submit your answer as a comment or thread in this Gist. Please submit your solution *separately* *

You should provide your solution by submitting your code in the form of a Gist or GitHub repository. 🤝

## Questions ❓

Email us :)

Look forward to speaking with you soon!