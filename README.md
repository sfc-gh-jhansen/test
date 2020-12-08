# Snowflake Citibike dbt Demo
Welcome to the Snowflake Citibike dbt demo! This demo can be run from the command line using the *dbt CLI* or through a web UI using *dbt Cloud*. The *dbt CLI* is the free, open-source version of dbt while *dbt Cloud* is a subscription based service. See below for more details but *dbt Cloud* does offer a free *Developer* edition which you can use for the demo.

This documentation assumes that you already have a demo account setup with the newest version of [Citibike](https://github.com/snowflakecorp/citibike).

## dbt Setup

Depending on how you'd like to run the demo please follow one or both of these setup steps. It is recommended that you set up both so that you understand how they work and so that you can demo either.

<table>
<tr>
<th width=50%>dbt CLI Setup</th>
<th width=50%>dbt Cloud Setup</th>
</tr>
<tr valign="top">
<td>

To get setup to run the Snowflake Citibike dbt demo from the command line, using the **dbt CLI** follow these steps.

### 1. Install dbt
Please follow [dbt's Installation steps](https://docs.getdbt.com/dbt-cli/installation/) to get the dbt CLI tool installed on your laptop.

### 2. Clone the project
Download a copy of this project to your laptop by either cloning the project or by downloading it as a zip file and unzipping to a target location.

### 3. Set environment variables
By default when dbt CLI runs it looks for a `profiles.yml` file in your `~/.dbt/` directory (see [Configure your profile](https://docs.getdbt.com/dbt-cli/configure-your-profile) for more details about how this file is setup). But to make things easier for this demo we've placed the `profiles.yml` file in the root of the project folder. Additionaly, we've configued the `profiles.yml` file to look to certain environment variables for the environment specific details. To set those variables, run these commands (for bash and zsh shells) replacing the items in angled brackets <> with actual values:

```zsh
export DBT_PROFILES_DIR='<Path to project root>'
export DBT_SNOWFLAKE_ACCOUNT='<Snowflake account>'
export DBT_SNOWFLAKE_USER='<Snowflake user>'
export DBT_SNOWFLAKE_PASSWORD='<Snowflake password>'
```

Note, for the `DBT_SNOWFLAKE_ACCOUNT` variable give the Snowflake accounts as `az_demo134.east-us-2.azure`.

</td><td>

To get setup to run the Snowflake Citibike dbt demo from a web UI, using the **dbt Cloud** follow these steps.

### 1. Sign up for dbt Cloud
To sign up for a free Developer plan with **dbt Cloud** visit the [dbt Cloud Sign Up](https://cloud.getdbt.com/signup/) page and complete the sign up form.

### 2. Fork the GitHub Repository
In order for **dbt Cloud** to connect a self-hosted GitHub repository you need a GitHub repository that you have admin access to (so you can enable read/write access to it from **dbt Cloud**). The easiest way to do this is to fork [the official Snowflake Citibike dbt repository](https://github.com/sfc-gh-aeldridge/citibike-dbt-demo). To do that, follow these steps

1. Login into [GitHub](https://github.com/login)
1. Open [the official Snowflake Citibike dbt repository](https://github.com/sfc-gh-aeldridge/citibike-dbt-demo)
1. Click on the **Fork** icon in the upper right and create the fork in your Snowflake GitHub account (named "sfc-gh-&lt;username&gt;")

### 3. Create a new dbt Cloud Project
In this step you will create a new dbt Cloud project and connect it to your forked GitHub repository.

1. Login to [dbt Cloud](https://cloud.getdbt.com/login/)
1. Click on the pancake icon in the upper left and select **Account Settings**
1. Click on the **New Project** button near the top right of the page
1. Fill out the required project details
   1. One the Database Connection page, select "Snowflake" as the data warehouse and fill in the connection details
   1. On the Repository setup page, select "Git URL" as the repository type and enter the URL to your forked repository (using the SSH URL)
   1. Follow the steps on the [Importing a project by git URL](https://docs.getdbt.com/docs/dbt-cloud/cloud-configuring-dbt-cloud/cloud-import-a-project-by-git-url/) page to allow **dbt Cloud** to connect to your forked repository

There is a current bug in dbt Cloud that requires you to manually enter the branch name in the environment.

1. Login to [dbt Cloud](https://cloud.getdbt.com/login/)
1. Make sure you have the correct project selected (in the top navbar)
1. Click on the pancake icon in the upper left and select **Environments**
1. Click on the environment for this project
1. Click on the **Settings** button near the top right
1. Click on the **Edit** button near the top right
1. Make sure the **Custom Branch** box is selected and enter *main* in the **Branch** box
1. Click on the **Save** button near the top right

</td>
</tr>
</table>

## Snowflake Setup
Before running this demo you must setup a few things in your Snowflake demo account.

### Run demo_setup.sql Script
The demo setup script is contained in the `/analysis` folder of this repository. See the [dbt Analyses overview](https://docs.getdbt.com/docs/building-a-dbt-project/analyses/) for more details.

1. Run the `dbt compile` command (this will compile all the models and scripts in the analysis folder)
1. Open up the script located in the `target/compiled/{project name}/analysis/` folder
1. Copy/Paste the contents of the script and run them in your demo account

### Seed the gbfs_config Table
This demo also makes use of the [dbt Seed feature](https://docs.getdbt.com/docs/building-a-dbt-project/seeds/). In order to run the models in the `models/utils` folder (and ultimately to build the `stations` table) we need to have the `gbfs_config` table created. The content for the table lives in the `data/utils/gbfs_config.csv` file. To build this seed table in your demo environment run the following command:

```zsh
dbt seed
```

## dbt Command Summary
Here is the complete list of dbt commands that are available either through the **dbt CLI** or **dbt Cloud**. See [dbt Command reference](https://docs.getdbt.com/reference/dbt-commands) for the up-to-date list.

* [debug](https://docs.getdbt.com/reference/commands/debug) (CLI only): debugs dbt connections and projects
* [init](https://docs.getdbt.com/reference/commands/init) (CLI only): initializes a new dbt project
* [compile](https://docs.getdbt.com/reference/commands/compile): compiles (but does not run) the models in a project
* [run](https://docs.getdbt.com/reference/commands/run): runs the models in a project
* [test](https://docs.getdbt.com/reference/commands/test): executes tests defined in a project
* [deps](https://docs.getdbt.com/reference/commands/deps): downloads dependencies for a project
* [snapshot](https://docs.getdbt.com/reference/commands/snapshot): executes "snapshot" jobs defined in a project
* [clean](https://docs.getdbt.com/reference/commands/clean): deletes artifacts present in the dbt project
* [seed](https://docs.getdbt.com/reference/commands/seed): loads CSV files into the database
* [docs](https://docs.getdbt.com/reference/commands/cmd-docs) (CLI only): generates documentation for a project
* [source](https://docs.getdbt.com/reference/commands/source): provides tools for working with source data (including validating that sources are "fresh")
* [run-operation](https://docs.getdbt.com/reference/commands/run-operation): runs arbitrary maintenance SQL against the database
* [rpc](https://docs.getdbt.com/reference/commands/rpc) (CLI only): runs an RPC server that clients can submit queries to
* [list](https://docs.getdbt.com/reference/commands/list) (CLI only): lists resources defined in a dbt project

In addition to the specific command documentation, it's important to understand the [dbt Selection Syntax](https://docs.getdbt.com/reference/node-selection/syntax) which is used in conjunction with many of these commands to specify the exact object(s) you wish to process.

## Features

### Running models
*See the dbt [run](https://docs.getdbt.com/reference/commands/run) command for more details*

You can execute, or run, a model by using the `dbt run` command. By default this will run all models in your project. To narrow the set of objects to run use the `--model` selector syntax. See the [dbt Selection Syntax](https://docs.getdbt.com/reference/node-selection/syntax) page for more details. Here are a few samples:

```zsh
dbt run --models gbfs_json   # runs a single model
dbt run --models utils       # runs models contained in the "utils" folder
dbt run --models tag:my_tag  # runs all models with the "my_tag" tag
```

If you have any models that depend on [dbt Seeds](#seeds), please sure that you run them first!

### Documentation
*See the dbt [docs](https://docs.getdbt.com/reference/commands/cmd-docs) command for more details*

To generate and view the docs generated by dbt, including the visual lineage diagram, run the following commands:

```zsh
dbt docs generate; dbt docs serve
```

### Seeds
*See the dbt [seed](https://docs.getdbt.com/reference/commands/seed) command for more details*

Make sure you run the dbt seeds before running any dependent models. This can be done with the `dbt seed` command:

```zsh
dbt seed
```

### Tests
*See the dbt [test](https://docs.getdbt.com/reference/commands/test) command for more details*

dbt tests provide a powerful way to ensure code quality in your dbt project. dbt tests come in two flavors, schema validation tests and custom tests. Here are a few samples:

```zsh
dbt test --models one_specific_model  # run tests for one_specific_model
dbt test --models some_package.*      # run tests for all models in package
dbt test --data                       # # run only custom data tests
dbt test --schema                     # run only schema tests
```

### Operations
*See the dbt [run-operation](https://docs.getdbt.com/reference/commands/run-operation) command for more details*

dbt operations are used to invoke a macro from the command line. See also the [Operations](https://docs.getdbt.com/docs/building-a-dbt-project/hooks-operations#operations) section. Operations aren't a separate resource in your project, but just a convenient way to invoke a macro. Here are a few samples:

```zsh
dbt run-operation citibike_add_trips                             # run a macro
dbt run-operation citibike_add_update_stations                   # run a macro
dbt run-operation citibike_add_trips --args '{num_records: 50}'  # run a macro with arguments
```
