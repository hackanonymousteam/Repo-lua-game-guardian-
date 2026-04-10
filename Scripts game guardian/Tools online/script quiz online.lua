local function getQuiz()
    local request = gg.makeRequest('https://opentdb.com/api.php?amount=1&type=multiple&category=9')

    if request == nil or request.content == nil then
        print('Erro get reply server.')
        return
    end

    local response = request.content
    local question, correct_answer, incorrect_answers = nil, nil, {}

    question = response:match('"question":"(.-)"'):gsub("&quot;", '"'):gsub("&#039;", "'"):gsub("&amp;", "&")

    correct_answer = response:match('"correct_answer":"(.-)"'):gsub("&quot;", '"'):gsub("&#039;", "'"):gsub("&amp;", "&")

    for a in response:gmatch('"incorrect_answers"%s*:%s*%[(.-)%]') do
        for answer in a:gmatch('"(.-)"') do
            answer = answer:gsub("&quot;", '"'):gsub("&#039;", "'"):gsub("&amp;", "&")
            table.insert(incorrect_answers, answer)
        end
    end

      if question and correct_answer and #incorrect_answers > 0 then
             local answers = {correct_answer, table.unpack(incorrect_answers)}
        
        
        math.randomseed(os.time())
        for i = #answers, 2, -1 do
            local j = math.random(i)
            answers[i], answers[j] = answers[j], answers[i]
        end
        
        
        local choice
        repeat
            
            choice = gg.choice(answers, nil, 'question: ' .. question)
            if choice == nil then
                return 
         end
        until choice ~= nil
        
        if choice == #answers then
                       elseif answers[choice] == correct_answer then
            gg.alert(' correct')
        else
            gg.alert(' incorret!')
        end

             local Alert = gg.alert('New question?', 'yes', 'no')
        if Alert == 1 then
            getQuiz() 
        elseif Alert == 2 then
            os.exit() 
        end
    else
        print('Erro get reply server.')
    end
end

getQuiz()