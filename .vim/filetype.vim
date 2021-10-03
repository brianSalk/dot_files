" my filetype file
if exists("did_load_filetypes")
  finish
endif
augroup filetypedetect
  au! BufRead,BufNewFile *.fasta		setfiletype fasta
  au! BufRead,BufNewFile *.fa		setfiletype fasta
augroup END
