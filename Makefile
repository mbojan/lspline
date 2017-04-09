default: README.md vignettes/lspline.html

README.md: vignettes/lspline.Rmd
		cp vignettes/lspline.Rmd README.Rmd
		Rscript -e "rmarkdown::render('README.Rmd', output_format='github_document', output_file='README.md', params=list(figpath='vignettes/lspline-'))"
		rm README.Rmd

vignettes/lspline.html: vignettes/lspline.Rmd
		Rscript -e "rmarkdown::render('$<', output_format='html_vignette')"

.PHONY: default
