provider "aws" {
  region = "eu-west-1"
  default_tags {
    tags = {
       Lifecycle = "testing"
    }
  }
}

variables {
  sitename = "tofutest"
  environment = "qa"
}

run "valid_bucket_name" {
  command = plan

  assert {
    condition = aws_s3_bucket.website.bucket == "site-tofutest-qa-html"
    error_message = "S3 bucket name did not match"
  }
}

run "sitename_validation" {
  command = plan
  variables {
    sitename = "tofu.test"
  }
  expect_failures = [
    var.sitename
  ]
}

run "deploy_html" {
  command = apply

  assert {
    condition = aws_s3_object.index.etag == filemd5("./site/index.html")
    error_message = "index.html MD5 hash does not match source"
  }
}

run "resolve_endpoint" {
  module {
    source = "./tests/e2e"
  }
  variables {
    endpoint_url = "http://${run.deploy_html.endpoint}"
  }
  assert {
    condition = data.http.request.status_code == 200
    error_message = "HTTP code ${data.http.request.status_code} returned from endpoint"
  }
}


