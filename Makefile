default: README.md

README.md: vignettes/lspline.Rmd
		cp vignettes/lspline.Rmd README.Rmd
		Rscript -e "rmarkdown::render('README.Rmd', output_format='github_document', output_file='README.md', params=list(figpath='vignettes/lspline-'))"
		rm README.Rmd

.PHONY: default
