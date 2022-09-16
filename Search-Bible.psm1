function Search-Bible {

    param(
        [Parameter(Mandatory)]
        [string]$Expression,
        [Parameter(Mandatory)]
        [ValidateSet("Genesis","Exodo","Levitico","Numeros","Deuteronomio","Josue","Juizes","Rute","1 Samuel","2 Samuel","1 Reis","2 Reis","1 Cronicas","2 Cronicas","Esdras","Neemias","Ester","Jó","Salmos","Proverbios","Eclesiastes","Canticos","Isaias","Jeremias","Lamentacoes","Ezequiel","Daniel","Oseias","Joel","Amos","Obadias","Jonas","Miqueias","Naum","Habacuque","Sofonias","Ageu","Zacarias","Malaquias","Mateus","Marcos","Lucas","Joao","Atos","Romanos","1 Corintios","2 Corintios","Galatas","Efesios","Filipenses","Colossenses","1 Tessalonicenses","2 Tessalonicenses","1 Timoteo","2 Timoteo","Tito","Filemom","Hebreus","Tiago","1 Pedro","2 Pedro","1 Joao","2 Joao","3 Joao","Judas","Apocalipse")]
        [string]$Book,
        [Parameter(Mandatory)]
        [ValidateSet("Almeida Revista e Atualizada","Nova Versao Transformadora","Nova Almeida Atualizada","Almeida Revista e Corrigida","Nova Versao Internacional","Almeida Corrigida Fiel")]
        [string]$Version
    )

    Write-Host ""

    Write-Host "       ************************************"
    Write-Host "       ** BUSCA POR EXPRESSÕES NA BIBLIA **"
    Write-Host "       ************************************"

    Write-Host ""

    $line = Select-String `
        -Path 'C:\Program Files\PowerShell\7\Modules\Search-Bible\books.txt' `
        -Pattern "-> $($Book)"

    $sbook = (($line -split ':')[3] -split '->')[0].Trim()

    $line = Select-String `
        -Path 'C:\Program Files\PowerShell\7\Modules\Search-Bible\versions.txt' `
        -Pattern "-> $($Version)"

    $sversion = (($line -split ':')[3] -split '->')[0].Trim()

    Write-Host ""
    Write-Host `
        -BackgroundColor Black `
        -ForegroundColor Yellow `
        "...Procurando por '$($Expression)' no livro de $($Book) ($($Version))"
    Write-Host ""

    foreach ($chapter in 1..150) {
        $uri = "https://www.bibliaonline.com.br/$($sversion)/$($sbook)/$($chapter)"
        $r = $null
        $r = Invoke-WebRequest `
                -Uri $uri `
                -DisableKeepAlive `
                -SkipHttpErrorCheck

        if ($r.StatusCode -eq 200) {
            if ($r.Content | Select-String -Pattern $Expression -Quiet) {
                Write-Host `
                    -BackgroundColor Black `
                    -ForegroundColor Green `
                    "A expressao '$($Expression)' existe no capítulo $($chapter) do livro de $($Book)"
                Write-Host `
                    -BackgroundColor Black `
                    -ForegroundColor DarkGreen `
                    "[$($uri)]"
                Write-Host ""
            }
        }
        else { break }
    }

    Write-Host ""
}

Export-ModuleMember Search-Bible