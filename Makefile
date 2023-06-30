.PHONY: install_kind install_kubectl \
	create_kind_cluster create_docker_registry connect_registry_to_kind_network \
	connect_registry_to_kind create_kind_cluster_with_registry delete_kind_cluster \
	delete_docker_registry install_app uninstall_app build_docker_image \
	install_nginx_ingress clean_up run_end_to_end

# Dependencies

install_nginx_ingress:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml && \
	  kubectl wait --namespace ingress-nginx \
  		--for=condition=ready pod \
  		--selector=app.kubernetes.io/component=controller \
  		--timeout=90s

# Create cluster
create_docker_registry:
	if docker ps | grep -q 'local-registry'; \
	then echo "---> local-registry already created; skipping"; \
	else docker run --name local-registry -d --restart=always -p 5000:5000 registry:2; \
	fi

create_kind_cluster: create_docker_registry
	kind create cluster --name sampleapp.com --config kind_config.yml || true && \
	  kubectl get nodes

connect_registry_to_kind_network:
	docker network connect kind local-registry || true

connect_registry_to_kind: connect_registry_to_kind_network
	kubectl apply -f kind_configmap.yml

create_kind_cluster_with_registry:
	$(MAKE) create_kind_cluster && $(MAKE) connect_registry_to_kind

# Bootstrap application
build_docker_image:
	docker build -t sampleapp.com . && \
	  docker tag sampleapp.com 127.0.0.1:5000/sampleapp.com && \
	    docker push 127.0.0.1:5000/sampleapp.com 

# Run application
install_app: build_docker_image install_nginx_ingress
	helm upgrade --atomic --install sampleapp-website ./chart

# Run end-to-end
run_end_to_end:
	$(MAKE) create_kind_cluster_with_registry && $(MAKE) install_app

# Clean up
delete_docker_registry: 
	docker stop local-registry && docker rm local-registry

delete_kind_cluster: delete_docker_registry
	kind delete cluster --name sampleapp.com

uninstall_app:
	helm uninstall sampleapp-website

clean_up:
	$(MAKE) uninstall_app || true && $(MAKE) delete_kind_cluster
