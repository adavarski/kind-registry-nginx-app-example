Pre-requisites: 

## Requirements

- Docker 
- [Kind installed](https://kind.sigs.k8s.io/)


### /etc/hosts 

Run `sudo vi /etc/hosts`, and add the following to the end of the file with a domain name of your choosing:

`127.0.0.1   sampleapp.com`

Note: (Optional): Feel free to change `sampleapp.com` to any other domain name of your choosing:
```
`cd ./chart/values.yaml` and replace the value of `ingressHostName`
```

Commands to run:
Run the folowing only if the pre-requisites stated above are all satisfied
- Run `make create_kind_cluster_with_registry` to create a kind cluster
- Run the application with `make install_app`
- Run `make clean_up` to clean up

Alternatively,
- Run `make run_end_to_end` to deploy the application
- `make clean_up` to clean up

Check:
```
$ curl sampleapp.com
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>K8s Project</title>
</head>
<body>
    <p>Deploy to kubernetes</p>
</body>
</html>
```
