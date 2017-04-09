default: README.md

README.md: vignettes/lspline.Rmd
		cp vignettes/lspline.Rmd README.Rmd
		mkdir -p tools
		Rscript -e "rmarkdown::render('README.Rmd', output_format='github_document', output_file='README.md', params=list(figpath='tools/lspline-'))"
		rm README.Rmd

.PHONY: default
