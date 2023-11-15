Rabbit.create(
    [{name: "Sparky", color: "brown"},
    {name: "Scotty", color: "pink"},
    {name: "Remmy", color: "grey"},
    {name: "Steevie", color: "purple"},
    {name: "Timmy", color: "black"},
    {name: "Debbie", color: "red"},
    {name: "Sergie", color: "blue"},
    {name: "Appie", color: "orange"},
    {name: "Ginny", color: "white"},
    {name: "Larry", color: "green"}])

Speech.create([
    {id:1,text:"introduction-1", rabbit_id: 1},
    {id:2,text:"introduction-2", rabbit_id: 1},
    {id:3,text:"introduction-3A", rabbit_id: 1},
    {id:4,text:"introduction-3B", rabbit_id: 1},
    {id:5,text:"introduction-4A-N", rabbit_id: 1},
    {id:6,text:"introduction-4-Y", rabbit_id: 1},
    {id:7,text:"introduction-4B-N", rabbit_id: 1},
    {id:8,text:"introduction-5", rabbit_id: 1},
    {id:9,text:"introduction-6", rabbit_id: 1},
    {id:10,text:"introduction-7", rabbit_id: 1},
])

SpeechBranch.create([
    {current_speech_id: 1, follow_speech_id: 2},
    {current_speech_id: 2, follow_speech_id: 3},
    {current_speech_id: 3, follow_speech_id: 5, answer: "no"},
    {current_speech_id: 3, follow_speech_id: 6, answer: "yes"},
    {current_speech_id: 4, follow_speech_id: 6, answer: "yes"},
    {current_speech_id: 4, follow_speech_id: 7, answer: "no"},
    {current_speech_id: 5, follow_speech_id: 4, speech_exited: true},
    {current_speech_id: 7, follow_speech_id: 4, speech_exited: true},
    {current_speech_id: 6, follow_speech_id: 8},
    {current_speech_id: 8, follow_speech_id: 9},
    {current_speech_id: 9, follow_speech_id: 10}
])

Speech.create([
    {id:11,text:"hint-1", rabbit_id: 1, speech_type: "hint"},
    {id:12,text:"hint-ginny", rabbit_id: 1, speech_type: "hint"},
    {id:13,text:"hint-remmy", rabbit_id: 1, speech_type: "hint"},
    {id:14,text:"hint-debbie", rabbit_id: 1, speech_type: "hint"},
    {id:15,text:"hint-larry", rabbit_id: 1, speech_type: "hint"},
    {id:16,text:"hint-steevie", rabbit_id: 1, speech_type: "hint"},
    {id:17,text:"hint-sergie", rabbit_id: 1, speech_type: "hint"},
    {id:18,text:"hint-appie", rabbit_id: 1, speech_type: "hint"},
    {id:19,text:"hint-timmy", rabbit_id: 1, speech_type: "hint"}
])

SpeechBranch.create([
    {current_speech_id: 11, follow_speech_id: 12, answer: "ginny"},
    {current_speech_id: 12, follow_speech_id: 11, speech_exited: true},
    {current_speech_id: 11, follow_speech_id: 13, answer: "remmy"},
    {current_speech_id: 13, follow_speech_id: 11, speech_exited: true},
    {current_speech_id: 11, follow_speech_id: 14, answer: "debbie"},
    {current_speech_id: 14, follow_speech_id: 11, speech_exited: true},
    {current_speech_id: 11, follow_speech_id: 15, answer: "larry"},
    {current_speech_id: 15, follow_speech_id: 11, speech_exited: true},
    {current_speech_id: 11, follow_speech_id: 16, answer: "steevie"},
    {current_speech_id: 16, follow_speech_id: 11, speech_exited: true},
    {current_speech_id: 11, follow_speech_id: 17, answer: "sergie"},
    {current_speech_id: 17, follow_speech_id: 11, speech_exited: true},
    {current_speech_id: 11, follow_speech_id: 18, answer: "appie"},
    {current_speech_id: 18, follow_speech_id: 11, speech_exited: true},
    {current_speech_id: 11, follow_speech_id: 19, answer: "timmy"},
    {current_speech_id: 19, follow_speech_id: 11, speech_exited: true},
])




