# XeLaTeX (fontspec + STIX Two Text). Compile from the course folder so
# \graphicspath{{images/}} and \input{title} keep working. After a successful
# build the finished PDF is copied to PdfNotes/ at the repo root.
#
# Safe to load twice (root -r plus a course-local .latexmkrc that includes this).

return 1 if $main::LECTURE_NOTES_LATEXMKRC++;

use Cwd qw(abs_path getcwd);
use File::Basename qw(dirname);
use File::Spec;

$pdf_mode = 5;
$postscript_mode = $dvi_mode = 0;
$xelatex = 'xelatex -synctex=1 -interaction=nonstopmode %O %S';
$recorder = 1;

sub find_repo_root {
    my $dir = abs_path(getcwd());
    while (1) {
        my $has_marker =
            -d File::Spec->catdir($dir, 'PdfNotes')
            || -d File::Spec->catdir($dir, '00_TEMPLATE');
        return $dir if $has_marker && -f File::Spec->catfile($dir, '.latexmkrc');
        my $parent = dirname($dir);
        last if $parent eq $dir;
        $dir = $parent;
    }
    return abs_path(getcwd());
}

my $pdfnotes = File::Spec->catdir(find_repo_root(), 'PdfNotes');
$success_cmd = "mkdir -p \"$pdfnotes\" && cp -f %D \"$pdfnotes/\"";
