#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

data "aws_vpc" "pulsar_vpc" {
  id = "vpc-5a6ebf3c"
}

data "aws_subnet" "default" {
  id = "subnet-6e41d562"
}

/* Load balancer */
resource "aws_elb" "default" {
  name            = "pulsar-elb"
  instances       = aws_instance.proxy[*].id
  security_groups = [aws_security_group.elb.id]
  subnets         = [data.aws_subnet.default.id]

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 8080
    lb_protocol       = "http"
  }

  listener {
    instance_port     = 6650
    instance_protocol = "tcp"
    lb_port           = 6650
    lb_protocol       = "tcp"
  }

  cross_zone_load_balancing = false

  tags = {
    Name = "Pulsar-Load-Balancer"
  }
}
