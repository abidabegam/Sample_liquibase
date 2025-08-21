pipeline {
  agent { docker { image 'maven:3.9-eclipse-temurin-17' } }
  options { timestamps() }

  parameters {
    choice(name: 'ENV',     choices: ['local','aws'],                 description: 'Liquibase profile (maps to pom.xml profiles)')
    choice(name: 'ACTION',  choices: ['validate','updateSQL','update'], description: 'Liquibase action to run')
    booleanParam(name: 'APPLY_ON_AWS', defaultValue: false, description: 'Safety gate for AWS apply')
  }

  environment {
    MVN_PROFILE = "${params.ENV}"
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Bind DB creds (aws only)') {
      when { expression { params.ENV == 'aws' } }
      steps {
        withCredentials([usernamePassword(credentialsId: 'rds-postgres-creds',
                                          usernameVariable: 'DB_USER',
                                          passwordVariable: 'DB_PASS')]) {
          echo 'AWS DB creds bound.'
        }
      }
    }

    stage('Liquibase') {
      steps {
        script {
          def base = "mvn -B -P${env.MVN_PROFILE}"

          switch (params.ACTION) {
            case 'validate':
              sh "${base} liquibase:validate"
              break

            case 'updateSQL':
              sh "${base} liquibase:updateSQL -Dliquibase.outputFile=target/liquibase/migrate.sql"
              archiveArtifacts artifacts: 'target/liquibase/migrate.sql', fingerprint: true
              break

            case 'update':
              if (params.ENV == 'aws' && !params.APPLY_ON_AWS) {
                error "Refusing to run update on AWS unless APPLY_ON_AWS is true."
              }
              def credFlags = (params.ENV == 'aws')
                ? "-Dliquibase.username=${env.DB_USER} -Dliquibase.password=${env.DB_PASS}"
                : ""
              sh "${base} ${credFlags} liquibase:update"
              break
          }
        }
      }
    }
  }
}
