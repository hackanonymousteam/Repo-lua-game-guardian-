<?php

class Config {
    const MISTRAL_API_KEY = "YOUR_API_KEY";
    const MISTRAL_API_URL = "https://api.mistral.ai/v1/chat/completions";
    const MISTRAL_MODEL = "mistral-small-latest";
    

    // Configurações base (agora com ranges para variação)
    const NOTAS_POR_FRASE_MIN = 4;
    const NOTAS_POR_FRASE_MAX = 6;
    const TOTAL_FRASES_MIN = 3;
    const TOTAL_FRASES_MAX = 5;
    const PAUSA_ENTRE_FRASES = 0.3; // segundos
    
    // Ranges de variação
    const BPM_MIN = 80;
    const BPM_MAX = 160;
    const VELOCIDADE_MIN = 60;
    const VELOCIDADE_MAX = 110;
    const VELOCIDADE_DESTAQUE = 110; // Para última nota da frase
    
    // Pulses per quarter note
    const PPQ = 480;
}

class VinhetaGenerator {
    private $acordes = [
        'mi_maior' => ['Eb', 'G', 'Bb'],
        'la_maior' => ['Eb', 'Ab', 'C'],
        'si_maior' => ['D', 'F', 'Bb'],
        'do_maior' => ['C', 'E', 'G'],
        'sol_maior' => ['G', 'B', 'D'],
        'fa_maior' => ['F', 'A', 'C'],
        're_menor' => ['D', 'F', 'A'],      // Adicionando variedade
        'mi_menor' => ['E', 'G', 'B'],
        'la_menor' => ['A', 'C', 'E']
    ];
    
    // Estilos emocionais para variar o prompt
    private $estilos = [
        'alegre' => 'Use tonalidade maior, ritmo animado (predominância de colcheias e semicolcheias), notas ascendentes e finais conclusivos. Transmita otimismo e energia positiva.',
        
        'dramatico' => 'Use contraste rítmico, tensão harmônica, pausas expressivas e notas longas nos momentos-chave. Crie sensação de suspense ou emoção intensa.',
        
        'infantil' => 'Use intervalos simples (2as, 3as), ritmo saltitante com muitas colcheias, repetição de padrões e final brincalhão. Lembre brincadeiras de criança.',
        
        'tecnologico' => 'Use repetição rítmica, notas curtas e staccato (semicolcheias), padrões sequenciais e sensação de movimento mecânico. Som futurista/robótico.',
        
        'epico' => 'Use notas longas nos momentos climáticos, intervalos amplos (5as, 8as), sensação de grandiosidade e final triunfante. Inspire aventura e heroísmo.',
        
        'melancolico' => 'Use tonalidade menor, ritmo mais lento (semínimas e mínimas), notas descendentes e finais que geram reflexão. Transmita nostalgia ou saudade.',
        
        'misterioso' => 'Use pausas estratégicas, intervalos inesperados (4as aumentadas), dinâmica contrastante e final em aberto. Crie ambiente de suspense.',
        
        'jazz' => 'Use síncopes, notas swingadas (colcheias com leve antecipação), harmonias com 7as e 9as, final descontraído. Clube de jazz noturno.'
    ];
    
    private $instrumentosPopulares = [
        0 => 'Acoustic Grand Piano',
        24 => 'Nylon Guitar',
        25 => 'Steel Guitar',
        32 => 'Acoustic Bass',
        40 => 'Violin',
        41 => 'Viola',
        42 => 'Cello',
        48 => 'Strings Ensemble',
        52 => 'Choir Aahs',
        56 => 'Trumpet',
        64 => 'Soprano Sax',
        73 => 'Flute',
        74 => 'Recorder',
        75 => 'Pan Flute',
        80 => 'Lead 1 (Square)',
        81 => 'Lead 2 (Sawtooth)',
        89 => 'Pad 2 (Warm)',
        118 => 'Synth Drum',
        124 => 'Telephone Ring'
    ];
    
    private $instrumentoMelodia;
    private $instrumentoAcompanhamento;
    private $bpm;
    private $estiloEscolhido;
    
    public function __construct($instrumentoMelodia = null, $instrumentoAcompanhamento = null, $bpm = null) {
        // Se não especificado, escolhe aleatoriamente
        $this->instrumentoMelodia = $instrumentoMelodia ?? $this->escolherInstrumentoAleatorio();
        $this->instrumentoAcompanhamento = $instrumentoAcompanhamento ?? $this->escolherInstrumentoAleatorio();
        $this->bpm = $bpm ?? rand(Config::BPM_MIN, Config::BPM_MAX);
        
        // Escolher estilo aleatório
        $estilosArray = array_keys($this->estilos);
        $this->estiloEscolhido = $estilosArray[array_rand($estilosArray)];
    }
    
    private function escolherInstrumentoAleatorio() {
        $instrumentos = array_keys($this->instrumentosPopulares);
        return $instrumentos[array_rand($instrumentos)];
    }
    
    public function gerarVinheta($texto) {
        $prompt = $this->criarPrompt($texto);
        $resposta = $this->chamarMistral($prompt);
        
        $composicao = $this->processarResposta($resposta);
        
        // Adicionar metadados
        $composicao['metadata'] = [
            'bpm' => $this->bpm,
            'estilo' => $this->estiloEscolhido,
            'instrumento_melodia' => $this->instrumentoMelodia,
            'instrumento_acompanhamento' => $this->instrumentoAcompanhamento,
            'descricao_estilo' => $this->estilos[$this->estiloEscolhido]
        ];
        
        $midiFile = $this->gerarArquivoMIDI($composicao);
        
        return [
            'status' => 'success',
            'query' => $texto,
            'answer' => $this->gerarDescricao($texto),
            'midi_url' => $midiFile,
            'composicao' => $composicao
        ];
    }
    
    private function criarPrompt($texto) {
        // Gerar estrutura variável
        $notasPorFrase = rand(Config::NOTAS_POR_FRASE_MIN, Config::NOTAS_POR_FRASE_MAX);
        $totalFrases = rand(Config::TOTAL_FRASES_MIN, Config::TOTAL_FRASES_MAX);
        $totalNotas = $notasPorFrase * $totalFrases;
        
        // Escolher acordes base para dar direção harmônica
        $acordesChave = array_rand($this->acordes, 2);
        $tonalidadePrincipal = is_array($acordesChave) ? $acordesChave[0] : $acordesChave;
        $tonalidadeSecundaria = is_array($acordesChave) ? $acordesChave[1] : $acordesChave;
        
        return "Você é um compositor musical especializado em criar vinhetas e temas curtos.

TEMA DA VINHETA: \"{$texto}\"

CONTEXTO MUSICAL (SIGA ESTRITAMENTE):
Estilo: {$this->estiloEscolhido}
Diretriz: {$this->estilos[$this->estiloEscolhido]}

ESTRUTURA VARIÁVEL DESTA COMPOSIÇÃO:
- Total de notas: {$totalNotas}
- Frases: {$totalFrases} frases de {$notasPorFrase} notas cada
- Pausa de " . Config::PAUSA_ENTRE_FRASES . " segundos entre frases
- Última nota de cada frase deve ter duração maior (ênfase)
- EVITE padrões repetitivos usados anteriormente
- Crie algo ÚNICO para este estilo específico

ACORDES SUGERIDOS (use como base, mas pode variar):
- Tonalidade principal: {$tonalidadePrincipal} (" . implode(', ', $this->acordes[$tonalidadePrincipal]) . ")
- Tonalidade secundária: {$tonalidadeSecundaria} (" . implode(', ', $this->acordes[$tonalidadeSecundaria]) . ")

VALORES RÍTMICOS PERMITIDOS:
- 0.25 (semicolcheia) - uso conforme estilo
- 0.5 (colcheia) - uso conforme estilo
- 1 (semínima) - uso conforme estilo
- 2 (mínima) - uso conforme estilo
- 4 (semibreve) - uso conforme estilo

OBSERVAÇÕES IMPORTANTES:
1. A vinheta deve refletir o ESTILO solicitado: {$this->estiloEscolhido}
2. Use a tonalidade principal como âncora harmônica
3. Acompanhamento deve complementar a melodia, não competir
4. Crie algo memorável e com personalidade
5. DIFERENTE das vinhetas anteriores - seja original

FORMATO DE RESPOSTA EXATO:
MELODIA:
[C4/1, D4/0.5, E4/0.25, F4/2, ...] ({$totalNotas} notas)

ACOMPANHAMENTO:
[Eb3/1, G3/1, Bb3/2, ...] ({$totalNotas} notas)

TONALIDADES_USADAS:
[{$tonalidadePrincipal}, {$tonalidadeSecundaria}]

ESTILO_MUSICAL:
[{$this->estiloEscolhido} - breve descrição do que foi criado]

Gere agora a vinheta completa para o estilo {$this->estiloEscolhido}:";
    }
    
    private function chamarMistral($prompt) {
        $headers = [
            'Content-Type: application/json',
            'Authorization: Bearer ' . Config::MISTRAL_API_KEY,
            'Accept: application/json'
        ];
        
        // Temperatura variável para mais criatividade
        $temperatura = rand(70, 95) / 100; // 0.7 a 0.95
        
        $payload = [
            'model' => Config::MISTRAL_MODEL,
            'messages' => [
                [
                    'role' => 'system',
                    'content' => 'Você é um compositor versátil que cria vinhetas com personalidades distintas. Cada vinheta deve ser única e refletir o estilo solicitado. Evite repetição de padrões. Use criatividade harmônica e rítmica.'
                ],
                [
                    'role' => 'user', 
                    'content' => $prompt
                ]
            ],
            'max_tokens' => 1500,
            'temperature' => $temperatura
        ];
        
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, Config::MISTRAL_API_URL);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_TIMEOUT, 30);
        
        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);
        
        if ($httpCode !== 200) {
            throw new Exception("Erro na API Mistral: " . $response);
        }
        
        $data = json_decode($response, true);
        return $data['choices'][0]['message']['content'] ?? '';
    }
    
    private function processarResposta($resposta) {
        $vinheta = [
            'melodia' => [],
            'acompanhamento' => [],
            'tonalidades' => [],
            'estilo_musical' => ''
        ];
        
        // Extrair melodia
        if (preg_match('/MELODIA:\s*\[(.*?)\]/s', $resposta, $matches)) {
            $vinheta['melodia'] = $this->parseNotas($matches[1]);
        }
        
        // Extrair acompanhamento
        if (preg_match('/ACOMPANHAMENTO:\s*\[(.*?)\]/s', $resposta, $matches)) {
            $vinheta['acompanhamento'] = $this->parseNotas($matches[1]);
        }
        
        // Extrair tonalidades
        if (preg_match('/TONALIDADES_USADAS:\s*\[(.*?)\]/s', $resposta, $matches)) {
            $vinheta['tonalidades'] = array_map('trim', explode(',', $matches[1]));
        }
        
        // Extrair estilo musical
        if (preg_match('/ESTILO_MUSICAL:\s*\[(.*?)\]/s', $resposta, $matches)) {
            $vinheta['estilo_musical'] = trim($matches[1]);
        }
        
        return $vinheta;
    }
    
    private function parseNotas($notasString) {
        $notas = [];
        $notasArray = array_map('trim', explode(',', $notasString));
        
        foreach ($notasArray as $nota) {
            if (preg_match('/([A-G][#b]?)(\d+)\/(\d+(?:\.\d+)?)/', $nota, $matches)) {
                $notas[] = [
                    'nota' => $matches[1],
                    'oitava' => (int)$matches[2],
                    'duracao' => (float)$matches[3]
                ];
            }
        }
        
        return $notas;
    }
    
    private function gerarArquivoMIDI($vinheta) {
        $midiGenerator = new MidiGenerator(
            $this->bpm,
            $this->instrumentoMelodia,
            $this->instrumentoAcompanhamento
        );
        $midiData = $midiGenerator->gerarMIDI($vinheta);
        
        // Nome com metadados para fácil identificação
        $timestamp = date('Ymd_His');
        $estilo = substr($this->estiloEscolhido, 0, 3);
        $filename = "v_{$estilo}_{$this->bpm}bpm_{$timestamp}.mid";
        
        file_put_contents($filename, $midiData);
        
        return $filename;
    }
    
    private function gerarDescricao($texto) {
        $nomesInstrumentos = [
            $this->instrumentoMelodia => $this->instrumentosPopulares[$this->instrumentoMelodia] ?? "Program {$this->instrumentoMelodia}",
            $this->instrumentoAcompanhamento => $this->instrumentosPopulares[$this->instrumentoAcompanhamento] ?? "Program {$this->instrumentoAcompanhamento}"
        ];
        
        return "Vinheta {$this->estiloEscolhido} para '{$texto}' | {$this->bpm} BPM | Melodia: {$nomesInstrumentos[$this->instrumentoMelodia]} | Acomp: {$nomesInstrumentos[$this->instrumentoAcompanhamento]}";
    }
}

class MidiGenerator {
    private $bpm;
    private $ppq;
    private $tempoAtualTicks;
    private $instrumentoMelodia;
    private $instrumentoAcompanhamento;
    
    public function __construct($bpm = 120, $instrumentoMelodia = 0, $instrumentoAcompanhamento = 0) {
        $this->bpm = $bpm;
        $this->ppq = Config::PPQ;
        $this->tempoAtualTicks = 0;
        $this->instrumentoMelodia = $instrumentoMelodia;
        $this->instrumentoAcompanhamento = $instrumentoAcompanhamento;
    }
    
    private function beatsParaTicks($beats) {
        return (int)round($beats * $this->ppq);
    }
    
    public function gerarMIDI($vinheta) {
        $midiData = $this->criarCabecalhoMIDI();
        $midiData .= $this->criarTrilhaConfiguracao();
        $midiData .= $this->criarTrilhaMusical($vinheta);
        
        return $midiData;
    }
    
    private function criarCabecalhoMIDI() {
        $header = "MThd";
        $header .= pack("N", 6);
        $header .= pack("n", 1);
        $header .= pack("n", 2);
        $header .= pack("n", $this->ppq);
        
        return $header;
    }
    
    private function criarTrilhaConfiguracao() {
        $dadosTrilha = "";
        
        // Tempo (BPM)
        $dadosTrilha .= $this->variavelLength(0);
        $dadosTrilha .= pack("C", 0xFF);
        $dadosTrilha .= pack("C", 0x51);
        $dadosTrilha .= pack("C", 0x03);
        $microsPorQuarter = (int)(60000000 / $this->bpm);
        $dadosTrilha .= pack("C", ($microsPorQuarter >> 16) & 0xFF);
        $dadosTrilha .= pack("C", ($microsPorQuarter >> 8) & 0xFF);
        $dadosTrilha .= pack("C", $microsPorQuarter & 0xFF);
        
        // Nome da trilha
        $dadosTrilha .= $this->variavelLength(0);
        $dadosTrilha .= pack("C", 0xFF);
        $dadosTrilha .= pack("C", 0x03);
        $nomeTrilha = "Config {$this->bpm}BPM";
        $dadosTrilha .= pack("C", strlen($nomeTrilha));
        $dadosTrilha .= $nomeTrilha;
        
        // End of track
        $dadosTrilha .= $this->variavelLength(0);
        $dadosTrilha .= pack("C", 0xFF);
        $dadosTrilha .= pack("C", 0x2F);
        $dadosTrilha .= pack("C", 0x00);
        
        return "MTrk" . pack("N", strlen($dadosTrilha)) . $dadosTrilha;
    }
    
    private function adicionarProgramChange($trackData, $canal, $instrumento) {
        $trackData .= $this->variavelLength(0);
        $trackData .= pack("C", 0xC0 | $canal);
        $trackData .= pack("C", $instrumento);
        return $trackData;
    }
    
    private function criarTrilhaMusical($vinheta) {
        $dadosTrilha = "";
        $this->tempoAtualTicks = 0;
        
        // Nome da trilha
        $dadosTrilha .= $this->variavelLength(0);
        $dadosTrilha .= pack("C", 0xFF);
        $dadosTrilha .= pack("C", 0x03);
        $nomeTrilha = "Vinheta";
        $dadosTrilha .= pack("C", strlen($nomeTrilha));
        $dadosTrilha .= $nomeTrilha;
        
        // Program Changes
        $dadosTrilha = $this->adicionarProgramChange($dadosTrilha, 0, $this->instrumentoMelodia);
        $dadosTrilha = $this->adicionarProgramChange($dadosTrilha, 1, $this->instrumentoAcompanhamento);
        
        // Eventos musicais
        $eventos = $this->prepararEventosMusicais($vinheta);
        
        foreach ($eventos as $evento) {
            $deltaTicks = $evento['tempo_ticks'] - $this->tempoAtualTicks;
            if ($deltaTicks < 0) $deltaTicks = 0;
            
            $dadosTrilha .= $this->variavelLength($deltaTicks);
            $dadosTrilha .= pack("C", $evento['status'] | $evento['canal']);
            $dadosTrilha .= pack("C", $evento['nota']);
            $dadosTrilha .= pack("C", $evento['velocidade']);
            
            $this->tempoAtualTicks = $evento['tempo_ticks'];
        }
        
        // End of track
        $dadosTrilha .= $this->variavelLength(0);
        $dadosTrilha .= pack("C", 0xFF);
        $dadosTrilha .= pack("C", 0x2F);
        $dadosTrilha .= pack("C", 0x00);
        
        return "MTrk" . pack("N", strlen($dadosTrilha)) . $dadosTrilha;
    }
    
    private function prepararEventosMusicais($vinheta) {
        $eventos = [];
        $tempoAtualBeats = 0;
        $beatsPorSegundo = $this->bpm / 60;
        $pausaBeats = Config::PAUSA_ENTRE_FRASES * $beatsPorSegundo;
        
        // Determinar quantas notas por frase (baseado no total de notas)
        $totalNotas = count($vinheta['melodia']);
        $notasPorFrase = (int)($totalNotas / 4); // Assume 4 frases como padrão
        
        for ($i = 0; $i < $totalNotas; $i++) {
            $durMelodia = $vinheta['melodia'][$i]['duracao'] ?? 0;
            $durAcomp = $vinheta['acompanhamento'][$i]['duracao'] ?? 0;
            
            // Velocidade dinâmica - última nota da frase mais forte
            $velMelodia = Config::VELOCIDADE_MIN;
            $velAcomp = Config::VELOCIDADE_MIN;
            
            if (($i + 1) % $notasPorFrase === 0) {
                // Última nota da frase - mais forte
                $velMelodia = Config::VELOCIDADE_DESTAQUE;
                $velAcomp = Config::VELOCIDADE_DESTAQUE - 10;
            } else {
                // Variação aleatória para notas normais
                $velMelodia = rand(Config::VELOCIDADE_MIN, Config::VELOCIDADE_MAX);
                $velAcomp = rand(Config::VELOCIDADE_MIN, Config::VELOCIDADE_MAX - 10);
            }
            
            // Melodia
            if (isset($vinheta['melodia'][$i])) {
                $nota = $vinheta['melodia'][$i];
                $this->adicionarEventoNota(
                    $eventos, 
                    $nota, 
                    0, 
                    $tempoAtualBeats,
                    $velMelodia
                );
            }
            
            // Acompanhamento
            if (isset($vinheta['acompanhamento'][$i])) {
                $nota = $vinheta['acompanhamento'][$i];
                $this->adicionarEventoNota(
                    $eventos, 
                    $nota, 
                    1, 
                    $tempoAtualBeats,
                    $velAcomp
                );
            }
            
            $tempoAtualBeats += max($durMelodia, $durAcomp);
            
            // Pausa entre frases
            if (($i + 1) % $notasPorFrase === 0 && $i < $totalNotas - 1) {
                $tempoAtualBeats += $pausaBeats;
            }
        }
        
        // Ordenação robusta
        usort($eventos, function($a, $b) {
            if ($a['tempo_ticks'] === $b['tempo_ticks']) {
                if ($a['status'] !== $b['status']) {
                    return $a['status'] <=> $b['status']; // Note Off (0x80) antes de Note On (0x90)
                }
                return $a['canal'] <=> $b['canal'];
            }
            return $a['tempo_ticks'] <=> $b['tempo_ticks'];
        });
        
        return $eventos;
    }
    
    private function adicionarEventoNota(&$eventos, $nota, $canal, $tempoInicioBeats, $velocidade) {
        $notaMIDI = $this->notaParaMIDI($nota['nota'], $nota['oitava']);
        $tempoInicioTicks = $this->beatsParaTicks($tempoInicioBeats);
        $duracaoTicks = $this->beatsParaTicks($nota['duracao']);
        $tempoFimTicks = $tempoInicioTicks + $duracaoTicks;
        
        $eventos[] = [
            'tempo_ticks' => $tempoInicioTicks,
            'status' => 0x90,
            'canal' => $canal,
            'nota' => $notaMIDI,
            'velocidade' => $velocidade
        ];
        
        $eventos[] = [
            'tempo_ticks' => $tempoFimTicks,
            'status' => 0x80,
            'canal' => $canal,
            'nota' => $notaMIDI,
            'velocidade' => 0
        ];
    }
    
    private function notaParaMIDI($nota, $oitava) {
        $notasBase = [
            'C' => 0, 'C#' => 1, 'Db' => 1, 'D' => 2, 'D#' => 3, 
            'Eb' => 3, 'E' => 4, 'F' => 5, 'F#' => 6, 'Gb' => 6,
            'G' => 7, 'G#' => 8, 'Ab' => 8, 'A' => 9, 'A#' => 10,
            'Bb' => 10, 'B' => 11
        ];
        
        return $notasBase[$nota] + (($oitava + 1) * 12);
    }
    
    private function variavelLength($valor) {
        $bytes = [];
        $valor = intval($valor);
        
        if ($valor < 0) $valor = 0;
        
        do {
            $byte = $valor & 0x7F;
            $valor = $valor >> 7;
            array_unshift($bytes, $byte);
        } while ($valor > 0);
        
        for ($i = 0; $i < count($bytes) - 1; $i++) {
            $bytes[$i] |= 0x80;
        }
        
        return call_user_func_array('pack', array_merge(['C*'], $bytes));
    }
}

// Processamento da requisição
header('Content-Type: application/json');

try {
    if (!isset($_GET['text']) || empty(trim($_GET['text']))) {
        throw new Exception("Parâmetro 'text' é obrigatório");
    }
    
    $texto = trim($_GET['text']);
    
    if (strlen($texto) > 100) {
        throw new Exception("Texto muito longo. Máximo 100 caracteres.");
    }
    
    // Parâmetros opcionais (se não fornecidos, serão aleatórios)
    $instrumentoMelodia = isset($_GET['inst_melodia']) ? (int)$_GET['inst_melodia'] : null;
    $instrumentoAcompanhamento = isset($_GET['inst_acomp']) ? (int)$_GET['inst_acomp'] : null;
    $bpm = isset($_GET['bpm']) ? (int)$_GET['bpm'] : null;
    
    $gerador = new VinhetaGenerator($instrumentoMelodia, $instrumentoAcompanhamento, $bpm);
    $resultado = $gerador->gerarVinheta($texto);
    
    echo json_encode([
        'status' => 'success',
        'query' => $texto,
        'answer' => $resultado['answer'],
        'midi_url' => 'http://0.0.0.0:8080/' . $resultado['midi_url'],
        'metadata' => $resultado['composicao']['metadata'],
        'estilo_musical' => $resultado['composicao']['estilo_musical'],
        'tonalidades' => $resultado['composicao']['tonalidades']
    ], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);

} catch (Exception $e) {
    echo json_encode([
        'status' => 'error',
        'query' => $_GET['text'] ?? '',
        'answer' => '',
        'midi_url' => '',
        'error' => $e->getMessage()
    ], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
}
?>