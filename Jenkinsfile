node {
    stage('checkout'){
        //必须有，该checkout步骤将检出从源控制代码; scm是一个特殊变量，指示checkout步骤克隆触发此Pipeline运行的特定修订。
        echo "checkout from git repo..."
        checkout scm
    }

    //定义全局变量
    def mvnHome = tool('mvn3')

    env.PATH = "${mvnHome}/bin:${env.PATH}"

    def jarPath="${env.WORKSPACE}/eureka-server/target"

    stage('mvn build'){
        sh "mvn  clean package -U -Dmaven.test.skip=true"
    }

    stage('docker built'){

        sh "mv ${jarPath}/eureka-server-*.jar app.jar"

        sh "docker built -t ."
    }
}