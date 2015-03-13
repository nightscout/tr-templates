# `make test` genera un sitio de prueba en # http://test.endefensadelsl.org
# `make` o `make all` genera el sitio
#
# Toma todas los svg de las tapas y los convierte a tif
src_tapas = $(wildcard src/images/tapas/*.svg)
out_tapas = $(patsubst %.svg,%.tif,$(src_tapas))

SITE_URL=http://nightscout.github.io/tr-templates/

toggle-test-dest:
	# sed "s,^destination:.*,destination: /srv/http/test.endefensadelsl.org," \
		  # -i _config.yml

toggle-dest:
	# sed "s,^destination:.*,destination: /srv/http/endefensadelsl.org," \
		  # -i _config.yml

wercker-build:
	sed "s,^url:.*,url: ${SITE_URL}," \
		  -i _config.yml
	mkdir -p ${WERCKER_OUTPUT_DIR}/build
	bundle exec jekyll build --destination ${WERCKER_OUTPUT_DIR}/build
	cp Makefile ${WERCKER_OUTPUT_DIR}
	cp build.sh ${WERCKER_OUTPUT_DIR}
	ls -alh ${WERCKER_OUTPUT_DIR}/build

wercker-deploy:
	./build.sh

gh-build:
	sed "s,^url:.*,url: ${SITE_URL}," \
		  -i _config.yml
	bundle exec jekyll build

build:
	bundle exec jekyll build

test: toggle-test-dest build toggle-dest


deps:
	# sudo apt-get install cabal-install
	# cabal install pandoc pandoc-citeproc
	# travis_retry bundle install
	./install-travis-deps.sh
install:
	bundle install

travis: build

travis-upload:
	./build.sh

all: toggle-dest build

clean:
	rm -rf tmp src/tmp _site

# Magia!
%.tif: %.svg
	convert -colorspace CMYK -density 300 '$<' '$@'

# Todas las tapas juntas
tapas: $(out_tapas)
