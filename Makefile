pi:
	cd packer && \
	packer inspect . && \
	cd ..

pv:
	cd packer && \
	packer validate . && \
	cd ..

pb:
	cd packer && \
	packer build . && \
	cd ..

tfi:
	cd terraform && \
	terraform init && \
	cd ..

tfv:
	cd terraform && \
	terraform validate && \
	cd ..

tfa:
	cd terraform && \
	terraform apply -auto-approve && \
	cd ..

all:
	cd packer && \
	packer validate . && \
	packer build . && \
	cd ../terraform && \
	terraform init && \
	terraform validate && \
	terraform plan && \
	terraform apply -auto-approve && \
	cd ..
