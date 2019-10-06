node {
    stage('checkout'){
        //必须有，该checkout步骤将检出从源控制代码; scm是一个特殊变量，指示checkout步骤克隆触发此Pipeline运行的特定修订。
        echo "checkout from git repo..."
        checkout scm
    }
    def javaHome = tool('jdk1.8')
    def mvnHome = tool('mvn3')
    env.PATH = "${mvnHome}/bin:${env.PATH}"

    stage('mvn build docker image'){
        sh 'mvn  clean package'
        sh 'mvn package docker:build'
    }

    stage('mvn test'){
    sh "echo skip mvn test"
    }
}