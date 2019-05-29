# Build ecr-login separately first
FROM golang:alpine AS ecr

RUN  apk --no-cache add git \
  && go get -u github.com/awslabs/amazon-ecr-credential-helper/ecr-login/cli/docker-credential-ecr-login
#############################################################################################################################################
FROM docker

RUN apk update

RUN apk --no-cache add wget unzip jq python

RUN wget https://s3.amazonaws.com/aws-cli/awscli-bundle.zip

RUN unzip awscli-bundle.zip

RUN ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

ADD https://amazon-eks.s3-us-west-2.amazonaws.com/1.12.7/2019-03-27/bin/linux/amd64/aws-iam-authenticator /usr/local/bin/aws-iam-authenticator

RUN chmod +x /usr/local/bin/aws-iam-authenticator

ADD https://amazon-eks.s3-us-west-2.amazonaws.com/1.12.7/2019-03-27/bin/linux/amd64/kubectl /usr/local/bin/kubectl

RUN chmod +x /usr/local/bin/kubectl

RUN apk clean

COPY --from=ecr /go/bin/docker-credential-ecr-login /usr/local/bin/ecr-login

RUN systemctl enable docker

RUN systemctl start docker

RUN nohup bash -c "/usr/local/bin/ecr-login &"
