node {
    stage('checkout'){
        //必须有，该checkout步骤将检出从源控制代码; scm是一个特殊变量，指示checkout步骤克隆触发此Pipeline运行的特定修订。
        echo "checkout from git repo..."
        checkout scm
    }

    //为解决问题：version 变量怎样传进来 或则怎样设置，每次构建和发布时自动累加

    //修改为当前的项目名
    def projName="eureka-server"

    //设置服务端口号（全局唯一，不能重复，网关根据这个端口号查找服务)
    def exposePort="8307"

    //容器运行的端口号，与服务端口号保持一致
    def containerPort="8307"

    //maven 路径设置：jekins插件管理->全局工具配置->Manven安装
    def mvnHome = tool('mvn3')

    //maven工作路径添加到Linux全局环境变量路径下
    env.PATH = "${mvnHome}/bin:${env.PATH}"

    //env.WORKSPACE是jenkins当前的工作路径；
    def projHome="${env.WORKSPACE}/${projName}"

    //maven在项目里构建jar包的位置
    def targetDir="target"

    def jarHome="${projHome}/${targetDir}"

    //所有项目的镜像构建后统一命名
    def app="app.jar"

    //公司domain
    def domain="chp"

    //docker iamge tag
    def tag="${domain}/${projName}"

    //工程日志目录
    def projLog="${projHome}/logs"

    //容器日志目录
    def containerLog="/home/logs"

    //容器工作目录
    def contianerWorkDir="/home"

    //contain jar
    def containerApp="${contianerWorkDir}/${app}"

    //gc日志
    def gcLog="${projLog}/gc.log"

    stage('maven build'){
        sh "mvn  clean package -U -Dmaven.test.skip=true"
    }

    stage('docker build'){

        sh "mv ${jarHome}/${projName}-*.jar ${projHome}/${app}"

        sh "docker rmi -f ${tag}"

        sh "docker build -t ${tag} ."
    }

    stage('deploy'){

        sh "mkdir ${projLog}"

        //运行容器，换行时首尾要留空格
        sh "docker run -d --restart=on-failure:5 --privileged=true "+
                " -w ${contianerWorkDir} "+
                " -v ${projLog}:${containerLog} "+
                " -p ${exposePort}:${containerPort} "+
                " --name ${projName} ${tag} "+
                " java "+
                    " -Djava.security.egd=file:/dev/./urandom "+
                    " -Duser.timezone=Asia/Shanghai "+
                    " -XX:+PrintGCDateStamps "+
                    " -XX:+PrintGCTimeStamps "+
                    " -XX:+PrintGCDetails "+
                    " -XX:+HeapDumpOnOutOfMemoryError "+
                    " -Xloggc:${gcLog} "+
                    " -jar ${containerApp} "
    }
}