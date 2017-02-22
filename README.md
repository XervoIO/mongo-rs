mongo-rs
========

Creates mongo database host with an optional backup and scraper container

## Installation

```
$ npm install -g @xervo/mongo-rs
```

## Creating mongo database host

Orchestrate a new mongo host that will have a running mongo instance, a backup container, and metrics for mongo. The metrics and backup containers are optional.

- [Create services](#create-services)
- [Add admin user to mongo](#create-mongo-admin-user)
- [Setup replica set](#replica-sets)
- [Manual docker-compose actions](#manual-docker-compose-actions)

## Create services

To create the docker containers run the following command and complete the prompts.

```
$ mongo-rs up
```

Once the services have been created the next steps are to [initialize the replica set](#initializing-replica-set), and then [add the admin user](#create-mongo-admin-user).
Once those steps are completed, the ability to add members to the replica set will be available.

## Create mongo admin user

The admin user credentials are populated into the `initMongoUser.js`. The mongo admin user can be created after the `mongo-rs up` command has ran successfully.

```
$ docker exec -it mongo mongo /opt/conf/initMongoUser.js
```

## Replica sets

### [Initializing replica set](https://docs.mongodb.com/manual/tutorial/deploy-replica-set/#initiate-the-replica-set)

```
$ docker exec -it mongo mongo /opt/conf/initRS.js
```

### [Add Members to Replica Set](https://docs.mongodb.com/manual/reference/method/rs.add/#rs.add)

```
$ docker exec -it mongo mongo
> use admin
> db.auth(<username>, <password>)
> rs.add({ host: "<ip>:27017", priority: 0, arbiterOnly: false }) # This will add a secondary
> rs.addArb("<ip>:27017") # This will add an arbiter
```

## Manual docker-compose actions

After all of the services have been created, the manual docker-compose commands can be used.

### Starting docker-compose project

To manually start the docker-compose project run the command
```
$ docker-compose \
  --file /opt/conf/{{install}}/docker-compose.yml \
  --project-name mongo-rs \
  up -d --no-build
```

The `install` variable will be the same when prompted for the install name

### Stoping docker-compose project

```
$ docker-compose \
  --file /opt/conf/{{install}}/docker-compose.yml \
  --project-name mongo-rs \
  down
```

### Restarting docker-compose project

```
$ docker-compose \
  --file /opt/conf/{{install}}/docker-compose.yml \
  --project-name mongo-rs \
  restart
```
