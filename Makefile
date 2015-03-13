# `make test` genera un sitio de prueba en # http://test.endefensadelsl.org
# `make` o `make all` genera el sitio
#
# Toma todas los svg de las tapas y los convierte a tif
src_tapas = $(wildcard src/images/tapas/*.svg)
out_tapas = $(patsubst %.svg,%.tif,$(src_tapas))

toggle-test-dest:
	# sed "s,^destination:.*,destination: /srv/http/test.endefensadelsl.org," \
		  # -i _config.yml

toggle-dest:
	# sed "s,^destination:.*,destination: /srv/http/endefensadelsl.org," \
		  # -i _config.yml


gh-build:
	bundle exec jekyll build --baseurl http://nightscout.github.io/tr-templates/

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
