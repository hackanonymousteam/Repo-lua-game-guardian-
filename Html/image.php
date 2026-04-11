<?php

class Config {
    const MISTRAL_API_KEY = "YOUR_API_KEY";
    const MISTRAL_API_URL = "https://api.mistral.ai/v1/chat/completions";
    const MISTRAL_MODEL = "mistral-small-latest";
    
    // Configurações da imagem
    const CANVAS_WIDTH = 512;
    const CANVAS_HEIGHT = 512;
    const MAX_SHAPES = 15;
    const MIN_SHAPES = 5;
    
    // Limites de segurança
    const MAX_COORD = 4096;
    const MAX_SIZE = 2048;
    const MIN_SIZE = 1;
    const MAX_RADIUS = 1024;
    const MAX_LINE_THICKNESS = 50;
    const GRADIENT_MAX_SIZE = 1024;
    
    // Cache
    const CACHE_DIR = 'images';
    const CACHE_TTL = 86400 * 30; // 30 dias
    
    // Estilos visuais
    const ESTILOS = [
        'geometrico' => 'Use formas geométricas básicas (retângulos, círculos, triângulos). Crie padrões repetitivos e simétricos. Cores sólidas e contrastantes.',
        
        'abstrato' => 'Use formas orgânicas e sobrepostas. Crie profundidade com opacidade. Misture cores de forma livre e expressionista.',
        
        'minimalista' => 'Use poucas formas, muito espaço negativo. Cores limitadas (máximo 3). Linhas limpas e composição equilibrada.',
        
        'psicodelico' => 'Use cores vibrantes e contrastantes. Formas distorcidas e fluidas. Sobreposições com transparência. Energia visual intensa.',
        
        'tecnologico' => 'Use linhas retas, ângulos precisos, simetria digital. Cores frias (azuis, cinzas) com detalhes em neon. Estilo cyberpunk.',
        
        'organico' => 'Use formas que lembram natureza: curvas suaves, padrões de crescimento, texturas que imitam elementos naturais. Cores terra.',
        
        'construtivista' => 'Use formas geométricas em composição dinâmica. Cores primárias fortes. Inspirado na arte construtivista russa.',
        
        'gradiente' => 'Use principalmente gradientes suaves. Transições de cor complexas. Formas que se fundem umas nas outras.'
    ];
    
    // Paletas de cores predefinidas
    const PALETAS = [
        'vibrante' => ['#FF0066', '#00FF99', '#3366FF', '#FFCC00', '#9900FF'],
        'pastel' => ['#FFB3BA', '#BAFFC9', '#BAE1FF', '#FFFFBA', '#FFD9BA'],
        'escuro' => ['#1A1A2E', '#16213E', '#0F3460', '#E94560', '#533483'],
        'natureza' => ['#2C5F2D', '#97BC62', '#DAA89B', '#9E7B6E', '#4A6D7C'],
        'tecnologia' => ['#0B0C10', '#1F2833', '#C5C6C7', '#66FCF1', '#45A29E'],
        'retro' => ['#E76F51', '#F8A28C', '#E9C46A', '#2A9D8F', '#264653']
    ];
}

class ImageGenerator {
    private $estiloEscolhido;
    private $paletaEscolhida;
    private $canvasWidth;
    private $canvasHeight;
    private $seed;
    private $cacheDir;
    
    public function __construct($width = null, $height = null, $seed = null, $estilo = null) {
        $this->canvasWidth = $width ?? Config::CANVAS_WIDTH;
        $this->canvasHeight = $height ?? Config::CANVAS_HEIGHT;
        
        // Seed para reprodutibilidade
        $this->seed = $seed ?? rand(1, 999999);
        srand($this->seed);
        
        // Estilo pode ser fixo ou aleatório
        if ($estilo && isset(Config::ESTILOS[$estilo])) {
            $this->estiloEscolhido = $estilo;
        } else {
            $estilosArray = array_keys(Config::ESTILOS);
            $this->estiloEscolhido = $estilosArray[array_rand($estilosArray)];
        }
        
        // Paleta aleatória
        $paletasArray = array_keys(Config::PALETAS);
        $this->paletaEscolhida = $paletasArray[array_rand($paletasArray)];
        
        // Diretório de cache
        $this->cacheDir = __DIR__ . '/' . Config::CACHE_DIR;
        if (!is_dir($this->cacheDir)) {
            mkdir($this->cacheDir, 0755, true);
        }
    }
    
    private function clamp($value, $min, $max) {
        return max($min, min($max, (int)$value));
    }
    
    private function clampCoord($value) {
        return $this->clamp($value, 0, Config::MAX_COORD);
    }
    
    private function clampSize($value) {
        return $this->clamp($value, Config::MIN_SIZE, Config::MAX_SIZE);
    }
    
    private function getCacheKey($texto) {
        return md5($texto . $this->canvasWidth . $this->canvasHeight . 
                  $this->estiloEscolhido . $this->paletaEscolhida . $this->seed);
    }
    
    private function getCachedImage($cacheKey) {
        $cacheFile = $this->cacheDir . '/' . $cacheKey . '.png';
        $metaFile = $this->cacheDir . '/' . $cacheKey . '.json';
        
        if (file_exists($cacheFile) && file_exists($metaFile)) {
            // Verificar TTL
            if (time() - filemtime($cacheFile) < Config::CACHE_TTL) {
                $metadata = json_decode(file_get_contents($metaFile), true);
                return [
                    'filename' => $cacheFile,
                    'metadata' => $metadata
                ];
            }
        }
        
        return null;
    }
    
    private function saveToCache($cacheKey, $imagem, $metadata) {
        $cacheFile = $this->cacheDir . '/' . $cacheKey . '.png';
        $metaFile = $this->cacheDir . '/' . $cacheKey . '.json';
        
        imagepng($imagem, $cacheFile);
        file_put_contents($metaFile, json_encode($metadata, JSON_PRETTY_PRINT));
    }
    
    public function gerarImagem($texto, $forceRegenerate = false) {
        $cacheKey = $this->getCacheKey($texto);
        
        // Verificar cache
        if (!$forceRegenerate) {
            $cached = $this->getCachedImage($cacheKey);
            if ($cached) {
                return [
                    'status' => 'success',
                    'query' => $texto,
                    'descricao' => $cached['metadata']['descricao'],
                    'image_url' => Config::CACHE_DIR . '/' . $cacheKey . '.png',
                    'metadata' => $cached['metadata'],
                    'cached' => true,
                    'seed' => $this->seed
                ];
            }
        }
        
        // Gerar nova imagem
        $prompt = $this->criarPrompt($texto);
        $resposta = $this->chamarMistral($prompt);
        
        $instrucoes = $this->processarResposta($resposta);
        
        // Validar instruções
        if (empty($instrucoes['comandos'])) {
            throw new Exception("IA não gerou instruções válidas");
        }
        
        // Gerar imagem via GD
        $imagem = $this->gerarPNG($instrucoes);
        
        // Preparar metadados
        $metadata = [
            'descricao' => $this->gerarDescricao($texto),
            'estilo' => $this->estiloEscolhido,
            'paleta' => $this->paletaEscolhida,
            'width' => $this->canvasWidth,
            'height' => $this->canvasHeight,
            'seed' => $this->seed,
            'titulo' => $instrucoes['titulo'],
            'estilo_desc' => $instrucoes['estilo_desc'],
            'num_comandos' => count($instrucoes['comandos']),
            'timestamp' => time()
        ];
        
        // Salvar em cache
        $this->saveToCache($cacheKey, $imagem, $metadata);
        imagedestroy($imagem);
        
        return [
            'status' => 'success',
            'query' => $texto,
            'descricao' => $metadata['descricao'],
            'image_url' => Config::CACHE_DIR . '/' . $cacheKey . '.png',
            'metadata' => $metadata,
            'cached' => false,
            'seed' => $this->seed,
            'instrucoes' => $instrucoes // Opcional, pode remover em produção
        ];
    }
    
    private function criarPrompt($texto) {
        $numShapes = rand(Config::MIN_SHAPES, Config::MAX_SHAPES);
        $cores = Config::PALETAS[$this->paletaEscolhida];
        
        return "Você é um artista visual generativo que cria imagens através de instruções gráficas.

TEMA DA IMAGEM: \"{$texto}\"

ESTILO: {$this->estiloEscolhido}
DIRETRIZES ESTÉTICAS: {Config::ESTILOS[$this->estiloEscolhido]}

ESPECIFICAÇÕES TÉCNICAS:
- Canvas: {$this->canvasWidth}x{$this->canvasHeight} pixels
- Número de formas: {$numShapes} formas
- Paleta de cores sugerida: " . implode(', ', $cores) . "
- Você PODE usar outras cores, mas mantenha a harmonia
- Use opacidade/transparência para criar profundidade (0-255)

FORMAS DISPONÍVEIS:
1. RECT x y largura altura cor [opacidade]
   Exemplo: RECT 100 150 200 80 #FF0066 64

2. CIRCLE x y raio cor [opacidade]
   Exemplo: CIRCLE 256 256 120 #00FF99 127

3. LINE x1 y1 x2 y2 espessura cor [opacidade]
   Exemplo: LINE 0 256 512 256 5 #FFFFFF 255

4. TRIANGLE x1 y1 x2 y2 x3 y3 cor [opacidade]
   Exemplo: TRIANGLE 256 100 356 300 156 300 #3366FF 192

5. GRADIENT type x1 y1 x2 y2 cor1 cor2 [horizontal/vertical/radial]
   Exemplo: GRADIENT radial 256 256 256 256 #FF0066 #00FF99

6. POLYGON x1,y1 x2,y2 x3,y3 x4,y4 ... cor [opacidade]
   Exemplo: POLYGON 100,100 200,150 250,250 150,300 50,250 #FFCC00 128

REGRAS IMPORTANTES:
1. Crie composições visualmente interessantes
2. Use diferentes tamanhos e posições
3. Sobreponha formas para criar profundidade
4. A imagem deve refletir o TEMA e o ESTILO
5. Seja criativo e original
6. Evite padrões muito óbvios ou repetitivos
7. Pense na composição como um todo (equilíbrio, contraste, movimento)
8. MANTENHA TODAS COORDENADAS DENTRO DO CANVAS (0-{$this->canvasWidth} para x, 0-{$this->canvasHeight} para y)

FORMATO DE RESPOSTA EXATO:
TITLE: [Título da obra baseado no tema]
STYLE: [{$this->estiloEscolhido} - breve descrição do que foi criado]

INSTRUCTIONS:
[Suas instruções gráficas aqui, uma por linha]

Exemplo de formato:
INSTRUCTIONS:
GRADIENT vertical 0 0 {$this->canvasWidth} {$this->canvasHeight} #1a1a2e #16213e
CIRCLE 256 256 200 #e94560 64
RECT 100 400 312 80 #0f3460 255
CIRCLE 380 180 60 #00ff99 127
LINE 0 256 512 256 3 #ffffff 128

Gere agora as instruções para a imagem baseada no tema '{$texto}' e estilo {$this->estiloEscolhido}:";
    }
    
    private function chamarMistral($prompt) {
        $headers = [
            'Content-Type: application/json',
            'Authorization: Bearer ' . Config::MISTRAL_API_KEY,
            'Accept: application/json'
        ];
        
        // Temperatura fixa para modo determinístico (0.8)
        $temperatura = 0.8;
        
        $payload = [
            'model' => Config::MISTRAL_MODEL,
            'messages' => [
                [
                    'role' => 'system',
                    'content' => 'Você é um artista generativo especializado em criar instruções gráficas precisas para gerar imagens únicas. Você entende de composição, teoria das cores e design. Cada imagem deve ser original e expressar o tema proposto. Responda SEMPRE no formato exato solicitado.'
                ],
                [
                    'role' => 'user', 
                    'content' => $prompt
                ]
            ],
            'max_tokens' => 2000,
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
        $instrucoes = [
            'titulo' => 'Sem título',
            'estilo_desc' => '',
            'comandos' => []
        ];
        
        // Extrair título
        if (preg_match('/TITLE:\s*(.+)/i', $resposta, $matches)) {
            $instrucoes['titulo'] = trim($matches[1]);
        }
        
        // Extrair estilo
        if (preg_match('/STYLE:\s*(.+)/i', $resposta, $matches)) {
            $instrucoes['estilo_desc'] = trim($matches[1]);
        }
        
        // Extrair instruções - método mais robusto
        if (preg_match('/INSTRUCTIONS:\s*(.*?)(?:\n\n|$)/is', $resposta, $matches)) {
            $linhas = explode("\n", trim($matches[1]));
            foreach ($linhas as $linha) {
                $linha = trim($linha);
                if (!empty($linha) && !preg_match('/^(TITLE|STYLE|INSTRUCTIONS)/i', $linha)) {
                    // Validar formato básico do comando
                    if (preg_match('/^(RECT|CIRCLE|LINE|TRIANGLE|GRADIENT|POLYGON)\s/i', $linha)) {
                        $instrucoes['comandos'][] = $linha;
                    }
                }
            }
        }
        
        return $instrucoes;
    }
    
    private function gerarPNG($instrucoes) {
        // Criar imagem
        $imagem = imagecreatetruecolor($this->canvasWidth, $this->canvasHeight);
        
        // Habilitar alpha channel
        imagealphablending($imagem, true);
        imagesavealpha($imagem, true);
        
        // Preencher fundo com transparência
        $fundo = imagecolorallocatealpha($imagem, 255, 255, 255, 127);
        imagefill($imagem, 0, 0, $fundo);
        
        // Processar cada comando
        foreach ($instrucoes['comandos'] as $comando) {
            try {
                $this->processarComando($imagem, $comando);
            } catch (Exception $e) {
                // Log do erro mas continua processando outros comandos
                error_log("Erro ao processar comando: $comando - " . $e->getMessage());
            }
        }
        
        return $imagem;
    }
    
    private function processarComando($imagem, $comando) {
        $partes = preg_split('/\s+/', trim($comando));
        if (empty($partes)) return;
        
        $tipo = strtoupper(array_shift($partes));
        
        switch ($tipo) {
            case 'RECT':
                $this->desenharRetangulo($imagem, $partes);
                break;
            case 'CIRCLE':
                $this->desenharCirculo($imagem, $partes);
                break;
            case 'LINE':
                $this->desenharLinha($imagem, $partes);
                break;
            case 'TRIANGLE':
                $this->desenharTriangulo($imagem, $partes);
                break;
            case 'GRADIENT':
                $this->desenharGradiente($imagem, $partes);
                break;
            case 'POLYGON':
                $this->desenharPoligono($imagem, $partes);
                break;
        }
    }
    
    private function converterOpacidade($opacidadeIA) {
        // IA usa 0-255, GD usa 0-127 (0 opaco, 127 transparente)
        $opacidadeIA = $this->clamp($opacidadeIA, 0, 255);
        return 127 - round(($opacidadeIA / 255) * 127);
    }
    
    private function desenharRetangulo($imagem, $params) {
        if (count($params) < 5) return;
        
        $x = $this->clampCoord($params[0]);
        $y = $this->clampCoord($params[1]);
        $w = $this->clampSize($params[2]);
        $h = $this->clampSize($params[3]);
        $cor = $params[4];
        
        // Garantir que não ultrapasse o canvas
        $x2 = min($x + $w, $this->canvasWidth);
        $y2 = min($y + $h, $this->canvasHeight);
        
        $opacidade = isset($params[5]) ? $this->converterOpacidade((int)$params[5]) : 0;
        
        $corAlocada = $this->hexToColorAllocate($imagem, $cor, $opacidade);
        
        if ($corAlocada !== false) {
            imagefilledrectangle($imagem, $x, $y, $x2, $y2, $corAlocada);
        }
    }
    
    private function desenharCirculo($imagem, $params) {
        if (count($params) < 4) return;
        
        $x = $this->clampCoord($params[0]);
        $y = $this->clampCoord($params[1]);
        $r = $this->clamp($params[2], 1, Config::MAX_RADIUS);
        $cor = $params[3];
        
        $opacidade = isset($params[4]) ? $this->converterOpacidade((int)$params[4]) : 0;
        
        $corAlocada = $this->hexToColorAllocate($imagem, $cor, $opacidade);
        
        if ($corAlocada !== false) {
            imagefilledellipse($imagem, $x, $y, $r * 2, $r * 2, $corAlocada);
        }
    }
    
    private function desenharLinha($imagem, $params) {
        if (count($params) < 6) return;
        
        $x1 = $this->clampCoord($params[0]);
        $y1 = $this->clampCoord($params[1]);
        $x2 = $this->clampCoord($params[2]);
        $y2 = $this->clampCoord($params[3]);
        $espessura = $this->clamp($params[4], 1, Config::MAX_LINE_THICKNESS);
        $cor = $params[5];
        
        $opacidade = isset($params[6]) ? $this->converterOpacidade((int)$params[6]) : 0;
        
        $corAlocada = $this->hexToColorAllocate($imagem, $cor, $opacidade);
        
        if ($corAlocada !== false) {
            imagesetthickness($imagem, $espessura);
            imageline($imagem, $x1, $y1, $x2, $y2, $corAlocada);
            imagesetthickness($imagem, 1); // Reset
        }
    }
    
    private function desenharTriangulo($imagem, $params) {
        if (count($params) < 7) return;
        
        $pontos = [
            $this->clampCoord($params[0]),
            $this->clampCoord($params[1]),
            $this->clampCoord($params[2]),
            $this->clampCoord($params[3]),
            $this->clampCoord($params[4]),
            $this->clampCoord($params[5])
        ];
        
        $cor = $params[6];
        $opacidade = isset($params[7]) ? $this->converterOpacidade((int)$params[7]) : 0;
        
        $corAlocada = $this->hexToColorAllocate($imagem, $cor, $opacidade);
        
        if ($corAlocada !== false) {
            imagefilledpolygon($imagem, $pontos, 3, $corAlocada);
        }
    }
    
    private function desenharGradiente($imagem, $params) {
        if (count($params) < 8) return;
        
        $tipo = strtolower($params[0]);
        
        // Limitar tamanho do gradiente para performance
        $x1 = $this->clampCoord($params[1]);
        $y1 = $this->clampCoord($params[2]);
        $x2 = $this->clampCoord(min($params[3], $x1 + Config::GRADIENT_MAX_SIZE));
        $y2 = $this->clampCoord(min($params[4], $y1 + Config::GRADIENT_MAX_SIZE));
        
        $cor1 = $params[5];
        $cor2 = $params[6];
        
        // Extrair cores RGB
        $rgb1 = $this->hexToRgb($cor1);
        $rgb2 = $this->hexToRgb($cor2);
        
        if ($tipo === 'horizontal') {
            for ($x = $x1; $x <= $x2; $x++) {
                $percent = ($x - $x1) / max(1, ($x2 - $x1));
                $r = (int)($rgb1['r'] + ($rgb2['r'] - $rgb1['r']) * $percent);
                $g = (int)($rgb1['g'] + ($rgb2['g'] - $rgb1['g']) * $percent);
                $b = (int)($rgb1['b'] + ($rgb2['b'] - $rgb1['b']) * $percent);
                
                $cor = imagecolorallocate($imagem, $r, $g, $b);
                imageline($imagem, $x, $y1, $x, $y2, $cor);
            }
        } elseif ($tipo === 'vertical') {
            for ($y = $y1; $y <= $y2; $y++) {
                $percent = ($y - $y1) / max(1, ($y2 - $y1));
                $r = (int)($rgb1['r'] + ($rgb2['r'] - $rgb1['r']) * $percent);
                $g = (int)($rgb1['g'] + ($rgb2['g'] - $rgb1['g']) * $percent);
                $b = (int)($rgb1['b'] + ($rgb2['b'] - $rgb1['b']) * $percent);
                
                $cor = imagecolorallocate($imagem, $r, $g, $b);
                imageline($imagem, $x1, $y, $x2, $y, $cor);
            }
        } elseif ($tipo === 'radial') {
            $cx = ($x1 + $x2) / 2;
            $cy = ($y1 + $y2) / 2;
            $raioMax = min($x2 - $x1, $y2 - $y1) / 2;
            $raioMax = min($raioMax, Config::MAX_RADIUS);
            
            // Desenhar do maior para o menor para suavizar
            for ($r = $raioMax; $r >= 0; $r--) {
                $percent = $r / max(1, $raioMax);
                $rCor = (int)($rgb1['r'] + ($rgb2['r'] - $rgb1['r']) * $percent);
                $gCor = (int)($rgb1['g'] + ($rgb2['g'] - $rgb1['g']) * $percent);
                $bCor = (int)($rgb1['b'] + ($rgb2['b'] - $rgb1['b']) * $percent);
                
                $cor = imagecolorallocate($imagem, $rCor, $gCor, $bCor);
                imagefilledellipse($imagem, $cx, $cy, $r * 2, $r * 2, $cor);
            }
        }
    }
    
    private function desenharPoligono($imagem, $params) {
        // Encontrar índice da cor (último ou penúltimo se tiver opacidade)
        $corIndex = count($params) - 1;
        $temOpacidade = isset($params[$corIndex]) && preg_match('/^#?[0-9A-Fa-f]{6}$/', $params[$corIndex - 1]);
        
        if ($temOpacidade) {
            $corIndex = count($params) - 2;
            $opacidade = $this->converterOpacidade((int)$params[count($params) - 1]);
        } else {
            $opacidade = 0;
        }
        
        if ($corIndex < 6) return; // Mínimo 3 pontos (6 coordenadas) + cor
        
        $cor = $params[$corIndex];
        
        // Processar pontos
        $pontos = [];
        for ($i = 0; $i < $corIndex; $i++) {
            // Suportar formato "x,y" ou "x y"
            if (strpos($params[$i], ',') !== false) {
                list($px, $py) = explode(',', $params[$i]);
                $pontos[] = $this->clampCoord($px);
                $pontos[] = $this->clampCoord($py);
            } else {
                $pontos[] = $this->clampCoord($params[$i]);
            }
        }
        
        $numPontos = count($pontos) / 2;
        if ($numPontos < 3) return;
        
        $corAlocada = $this->hexToColorAllocate($imagem, $cor, $opacidade);
        
        if ($corAlocada !== false) {
            imagefilledpolygon($imagem, $pontos, $numPontos, $corAlocada);
        }
    }
    
    private function hexToRgb($hex) {
        $hex = ltrim($hex, '#');
        if (strlen($hex) == 3) {
            $hex = $hex[0] . $hex[0] . $hex[1] . $hex[1] . $hex[2] . $hex[2];
        }
        
        return [
            'r' => hexdec(substr($hex, 0, 2)),
            'g' => hexdec(substr($hex, 2, 2)),
            'b' => hexdec(substr($hex, 4, 2))
        ];
    }
    
    private function hexToColorAllocate($imagem, $hex, $alpha = 0) {
        $rgb = $this->hexToRgb($hex);
        return imagecolorallocatealpha($imagem, $rgb['r'], $rgb['g'], $rgb['b'], $alpha);
    }
    
    private function gerarDescricao($texto) {
        return "Imagem {$this->estiloEscolhido} para '{$texto}' | {$this->canvasWidth}x{$this->canvasHeight} | Estilo: {$this->estiloEscolhido} | Paleta: {$this->paletaEscolhida} | Seed: {$this->seed}";
    }
}

// Processamento da requisição
header('Content-Type: application/json');

try {
    if (!isset($_GET['text']) || empty(trim($_GET['text']))) {
        throw new Exception("Parâmetro 'text' é obrigatório");
    }
    
    $texto = trim($_GET['text']);
    
    if (strlen($texto) > 200) {
        throw new Exception("Texto muito longo. Máximo 200 caracteres.");
    }
    
    // Parâmetros opcionais
    $width = isset($_GET['width']) ? (int)$_GET['width'] : Config::CANVAS_WIDTH;
    $height = isset($_GET['height']) ? (int)$_GET['height'] : Config::CANVAS_HEIGHT;
    $seed = isset($_GET['seed']) ? (int)$_GET['seed'] : null;
    $estilo = isset($_GET['estilo']) ? $_GET['estilo'] : null;
    $forceRegenerate = isset($_GET['force']) && $_GET['force'] === '1';
    
    // Validar dimensões
    if ($width < 64 || $width > 2048 || $height < 64 || $height > 2048) {
        throw new Exception("Dimensões devem estar entre 64 e 2048 pixels");
    }
    
    // Validar estilo se fornecido
    if ($estilo && !isset(Config::ESTILOS[$estilo])) {
        throw new Exception("Estilo inválido. Estilos disponíveis: " . implode(', ', array_keys(Config::ESTILOS)));
    }
    
    $gerador = new ImageGenerator($width, $height, $seed, $estilo);
    $resultado = $gerador->gerarImagem($texto, $forceRegenerate);
    
    echo json_encode([
        'status' => 'success',
        'query' => $texto,
        'descricao' => $resultado['descricao'],
        'image_url' => 'http://0.0.0.0:8080/' . $resultado['image_url'],
        'metadata' => $resultado['metadata'],
        'cached' => $resultado['cached'] ?? false,
        'seed' => $resultado['seed']
    ], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);

} catch (Exception $e) {
    echo json_encode([
        'status' => 'error',
        'query' => $_GET['text'] ?? '',
        'descricao' => '',
        'image_url' => '',
        'error' => $e->getMessage()
    ], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
}

// Endpoint para servir imagens do cache
if (isset($_GET['image']) && preg_match('/^[a-f0-9]{32}\.png$/', $_GET['image'])) {
    $imageFile = __DIR__ . '/' . Config::CACHE_DIR . '/' . $_GET['image'];
    if (file_exists($imageFile)) {
        header('Content-Type: image/png');
        header('Cache-Control: public, max-age=86400');
        readfile($imageFile);
        exit;
    }
}
?>