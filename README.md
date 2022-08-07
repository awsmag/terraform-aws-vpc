# aws-vpc-terraform

![awsmag.com](https://awsmag.com/content/images/2022/08/AWSMAG.com-Banner-1.png)

Terraform module to create a vpc with public and private subnets across multiple availability zones along with internet gateway and NAT gateway.

## Example

```hcl
module "vpc" {
  source = "awsmag/vpc/aws"
  # We recommend pinning every module to a specific version
  # version = "x.x.x"
  region = "eu-west-1"
  namespace = "tf-generated-vpc"
  cidr_block = "192.0.0.0/20"
  public_subnet_cidr = [ "192.0.1.0/24", "192.0.2.0/24", "192.0.3.0/24" ]
  private_subnet_cidr = [ "192.0.4.0/24", "192.0.5.0/24", "192.0.6.0/24" ]
}
```


