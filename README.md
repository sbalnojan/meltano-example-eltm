# Meltano Toy Projects: DataHub & Meltano
This Meltano repository explores how to use DataHub with Meltano. It contains a complete setup of:
- A local DataHub (using the datahub-cli & docker-compose)
- An AWS S3 mock + a postgres database
- A dbt (the [jaffle shop](https://github.com/dbt-labs/jaffle_shop)) project to transform some data
- And of course a meltano project which you could use to build up your own meltano + DataHub project.

## How to run this project?
Using this repository is really easy as it most of it runs inside docker via [batect](https://batect.dev/), a light-weight wrapper around docker. 

But you will need to have either a datahub server already runing somewhere to push the data to, or you use a local version. The connections
for the default local versions are preconfigured in the [meltano.yml](new_project/meltano.yml). 

```
  utilities:
  - name: datahub
    variant: datahub-project
    pip_url: acryl-datahub[s3,postgres,dbt]
    config:
      gms_host: http://host.docker.internal:8080
      # gms_auth: Not necessary for the local auth-less version, but likely necessary if you're running in production!
```

To get started with the local version, [install datahub](https://datahubproject.io/docs/quickstart) & then run the ```datahub docker quickstart``` command to launch the docker-compose cluster. After that you're all set up (you don't need to ingest sample data!)

By default, the UI will be located at http://localhost:9002/.

### Run with batect
We [batect](https://batect.dev/) because it makes it possible for you to run this project without even installing meltano. [Batect requires Java & Docker to be installed to run](https://batect.dev/docs/getting-started/requirements). 

The repository has a few configured "batect tasks" which essentially all spin up docker or docker-compose for you and do things inside these containers.

Run  ```./batect --list-tasks ``` to see the list of commands.

```./batect launch_mock``` for instance will launch two docker containers one with a mock AWS S3 endpoint and one with a postgres database.

Batect automatically tears down & cleans up after the task finishes.

### Run the project

1. Launch the mock endpoints in a separate terminal window ```./batect launch_mock```.

2. Launch meltano with batect via ```./batect melt```.
2.1. Alternatively you can use your local meltano, installed with ```pip install meltano```. (The mocks will still work.)
2.2 Run ```meltano install`` to install DataHub and the three needed plugins (s3, postgres, dbt)
3. Do a ELT run to fill the PostgreSQL database with raw & modelled data by running ```meltano run tap-s3-csv target-postgres dbt-postgres:run```

4. Next we're going to ingest the metadata. For S3 & PostgreSQL, you can run the recipes right away:

```meltano invoke datahub ingest -c s3recipe.dhub.yaml```
```meltano invoke datahub ingest -c postgresrecipe.dhub.yaml```

5. For dbt to provide us with metadata, we will also need to build the docs & the source freshness report by running
```meltano invoke dbt-postgres:docs-generate```
```meltano invoke dbt-postgres:freshness```

6. Finally, you can ingest the dbt metadata as well by running
```meltano invoke datahub ingest -c dbtrecipe.dhub.yaml```

7. Now you should be able to find all your metadata together in one place inside the DataHub. The local version is by default to be found at http://localhost:9002/. 