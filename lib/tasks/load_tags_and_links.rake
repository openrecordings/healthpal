desc 'Load tags and links for usability recordings'
task tags_and_links: :environment do

  id_offset = 3279

  [Recording.find(1), Recording.find(2)].each do |r|
    if r.id == 1 
      utts = utterances.delete_if {|u| u[0].round(-3) >= 4000}
    end
    if r.id == 2
      utts = utterances.delete_if {|u| u[0].round(-3) < 4000}
    end
    # loadtags(r, utts)
    loadlinks(r, utts)
  end
end

def loadtags(r, utts)
  # the min id for utterance records in r
  min_u_id = r.utterances.select(:id).min_by {|u| u.id}.id
  # the min id in the utterances array for utts
  umin_id = utts.min_by {|u| u[0]}[0]
  utts.each_with_index do |ut, i|
    utags = tags.find_all {|t| t[0] == umin_id + i}
    if utags
      puts utags.count
      utt = Utterance.find(min_u_id + i)
      utags.each do |t|
        puts t
        tag.create!(
          utterance: utterance.find(min_u_id + i),
          tag_type: tagtype.find(t[1])
        )
      end
    end
  end
end

def loadlinks(r, utts)
  # the min id for utterance records in r
  min_u_id = r.utterances.select(:id).min_by {|u| u.id}.id
  # the min id in the utterances array for utts
  umin_id = utts.min_by {|u| u[0]}[0]
  utts.each_with_index do |ut, i|
    ulinks = links.find_all {|l| l[3] == umin_id + i}
    if ulinks
      utt = Utterance.find(min_u_id + i)
      ulinks.each do |l|
        Link.create!(
          utterance: Utterance.find(min_u_id + i),
          label: l[1],
          url: l[2]
        )
      end
    end
  end
end

def utterances
  # id, text, start_time, end_time],
  [
    [3279,"So, I read your thing.  So let's, what's going with this first of all?",0,5],
    [3280,"I have no idea. Umm, it's feeling a little bit better today but it, it started off Sunday, just scratchy throat, then it turned into a bunch of drainage and constantly clearing my throat and then I got all congested up in here.  And now, it has just been really dry and still scratchy.",5,20],
    [3281,"Do you get allergies in the spring typically?",20,22],
    [3282,"No, but the allergist just -  I just went back and got my results from my lab work and he says I'm -",22,27],
    [3283,"Who says?",27,28],
    [3284,"He sent me to Osmond.",28,29],
    [3285,"Okay, okay.  Yes.",29,30],
    [3286,"_____ yeah and then it ended up doing an allergy test and said that I'm highly allergic to - dust, and then grass and ragweed were other ones that were high.  He did say -",30,42],
    [3287,"Mold is a pretty big one this time of the year.",42,44],
    [3288,"Yeah, because of all the snow -",44,46],
    [3289,"Yup.  Those tests are not what I recall scientifically awesome yet?",46,50],
    [3290,"Yeah.",50,52],
    [3291,"Yeah.  There was also this thing called provocative desensitization where it's like a whole different test you give, but, I was just kind of wondering if typically when the snow goes, if you get more of this?  So, that can be -",52,66],
    [3292,"Uhm, when like the weather changes.  I mean, I know a lot of people that are complaining of similar things -",66,72],
    [3293,"Um-hum. Flonase.  You got -",72,74],
    [3294,"Yeah.  Flonase -",74,76],
    [3295,"You can double up on that for a little while if it doesn't dry you out too much, okay?",76,80],
    [3296,"Okay.",80,81],
    [3297,"- you can increase the Flonase for a little while and see if that helps at least.  The other big thing you can use to kind of differentiate between is it more of an allergy thing or some type of an upper respiratory infection is your temperature.  So, if your temp's going up, it's probably more than just allergy.",81,95],
    [3298,"Well, I haven't kinda paid attention to that.  So far, I haven't had a temp, so far.",95,101],
    [3299,"Okay.  all right, so what else have we got here?",101,103],
    [3300,"Uhm.  I have the, I would say -",103,105],
    [3301,"The stomachy stuff.",105,106],
    [3302,"Yeah.",106,107],
    [3303,"So did you go to the higher doses of the omeprazole that we talked about?",107,111],
    [3304,"I didn't.  I, uhm.",111,112],
    [3305,"Okay.",112,114],
    [3306,"How is this all feeling?",114,115],
    [3307,"It's, ahh.  There are some days it's feeling a little better, like today.  Uhm, and another times, it just starts acting up again and the Pepto-Bismol, I tried that.",115,125],
    [3308,"Yeah.",125,126],
    [3309,"I was too worried about the Carafate after reading about the Carafate, so I tried the Pepto-Bismol and that seemed to - it kind of seemed to help -there was a note, I noticed it at least.",126,137],
    [3310,"Okay.",137,139],
    [3311,"Uhm.",139,141],
    [3312,"So, I'll say Pepto helped.  So, are you taking any of the omeprazole now?",141,146],
    [3313,"No.",146,147],
    [3314,"So, you stopped taking that entirely?",147,150],
    [3315,"Oh, wait.  No, omeprazole.  Yes.",150,155],
    [3316,"Yes.",155,156],
    [3317,"I was thinking Carafate.  I'm sorry.",156,159],
    [3318,"That's okay.  So the omeprazole you're taking 20?",159,162],
    [3319,"Yeah, if I took them.",162,164],
    [3320,"Okay.",164,165],
    [3321,"I haven't taken it today, but I took them yesterday.",165,168],
    [3322,"Okay.  So I'd say - ""Has been taking 20 mg of omeprazole.""",168,173],
    [3323,"And when I take that, as you know, but I'm worried about my heart.",173,177],
    [3324,"I know.  But, so worrying is a sensation that you're gonna have to keep on trusting that it's not in itself bad, so that worrying can kinda come and go just like the bad weather can come and go, but if you give it too much power, then it can help you stay in these loops that you just don't wanna stay in.",177,195],
    [3325,"I talked to, probably, 5 different people about my stomach systems and my bloating and all that stuff -",195,201],
    [3326,"Yeah.",201,202],
    [3327,"-'cause I do, I still have that happen and they are all like, ""It's gallbladder.  It is gallbladder.""  And so, I had my gallbladder removed.  That's exactly what it is.  Like you need to tell your doctor to check your gallbladder and I, I said, well I'm going in there and I looked online and some of the symptoms sounded about right, but I mean, I don't have pain in the right part of my back.",202,223],
    [3328,"But you, you don't always guess.  So you don't always get all of the above, but you had been?",223,229],
    [3329,"They told, when I went to the ER -",229,232],
    [3330,"Yeah.",232,233],
    [3331,"-for my stomach and they said I was constipated.  I don't know what labs he ran on, while in the ED, they said that your doctor can just run a CBC and a liver enzyme.",233,244],
    [3332,"BMP is gonna cover it.",244,246],
    [3333,"Yes, BMP will show liver enzymes.",246,249],
    [3334,"Yup.  It will show alk phos.  It will show uhm AST and ALT, which I'm pretty sure they had already done a while ago.",249,257],
    [3335,"Oh, my stomach had, that's about right when my stomach was really bothering me the most is when I went to the ER for it.",257,264],
    [3336,"So, this is interesting.  I logged for March 26, that's when you're in the emergency room I think, isn't this?",264,270],
    [3337,"Uh-hmm.  When I went in March, it's when the stomach pain has been going on for a little while now.",270,277],
    [3338,"Yeah.  So, your AST, ALT, alk phos were all normal.  So, that's good.  I - I - had looked at those when you initially had gone out, but I couldn't remember.",277,288],
    [3339,"Right.",288,289],
    [3340,"Okay, anything else for now that we need to think about?  I gotta check you over.",289,293],
    [3341,"Quick, I mentioned in the email, I don't know what's going on.",293,296],
    [3342,"Oh, that popping sound?",296,298],
    [3343,"I got, it's like gurgling, it's a carbonated water in the base of my head I can feel it here.",298,304],
    [3344,"When you move around?",304,305],
    [3345,"No.  Not still or when I move around - but the past couple of days, it's been happening frequently, and especially in the morning when I first got up, and I can feel the little bubbles like in the back of my spine.",305,317],
    [3346,"Like if you're totally stationary, do you notice this?",317,319],
    [3347,"Yeah.",319,321],
    [3348,"So, even if you didn't move about?",321,323],
    [3349,"Not constantly.",323,325],
    [3350,"I know, but try to pay attention and see if it happens around movement times.",325,328],
    [3351,"It's the bubbling and it's that part, why, why would that happen and what, why all of a sudden?",328,336],
    [3352,"I'm well, again, I'm not saying 100%, but since you got a bunch of upper respiratory stuff, it's probably because of that.",336,342],
    [3353,"Okay.",342,344],
    [3354,"Now, let me listen to your heart.  That sounds good, nice and regular.  I don't hear any jump beats.  Take breaths in and out.",344,355],
    [3355,"Good.  Your lungs sound nice and clear.  all right my man, let's get together in 3 to 4 weeks.  What do you think?  Four weeks sound good on your end?  And you see Cardiology.  No, you're gonna see GI.",355,367],
    [3356,"I'm seeing GI.",367,368],
    [3357,"Next week.",368,369],
    [3358,"Can you, just real quick -",369,371],
    [3359,"Yeah.",371,372],
    [3360,"Uhm feel my belly.",372,373],
    [3361,"Yeah.",373,374],
    [3362,"It does still bother me, it's ah..",374,377],
    [3363,"I was thinking about it when I was listening to your lungs, but I though ­­-",377,381],
    [3364,"I fell, like twice now.",381,383],
    [3365,"Yeah.  It sounds pretty good.  When did you eat last roughly?",383,386],
    [3366,"Uh-hmm, about 45 minutes ago.",386,389],
    [3367,"My hands are buried, but it's just hand, but I'm not feeling anything that makes me worried.",389,394],
    [3368,"Okay.",394,395],
    [3369,"And I think that, I think you probably have gastritis.  It will probably come and go again.  I mean, it's with the laryngitis that you had GI stuff and that's what _____ right as well.  So, really, really embrace those body goals.",395,410],
    [3370,"Okay.",410,411],
    [3371,"all right, bye then.",411,413],
    [3372,"all right, thanks.",413,414],
    [3373,"You're welcome.",414,415],
    [3374,"Okay.",415,416],
    [4215,"How are you feeling overall?",0,2],
    [4216,"Well, you notice when I do this -",2,3],
    [4217,"Um-hum.",3,4],
    [4218,"- in my foot.",4,5],
    [4219,"Um-hum.",5,6],
    [4220,"Then my both legs now.",6,8],
    [4221,"Yeah.",8,9],
    [4222,"But the pain, I can control in the back, you know, with the Norco, and ah, what is that other stuff that you gave me?",9,14],
    [4223,"Gabapentin maybe?",14,16],
    [4224,"No, no, no.",16,17],
    [4225,"Or the Tramadol?",17,18],
    [4226,"Yeah. Those 2 helped with the pain that I have from the surgery on my back but they don't help nerve.",18,22],
    [4227,"Right.  Well, they can to a point but not -",22,25],
    [4228,"I don't feel well on some days.",25,27],
    [4229,"And your blood pressure is pretty high today as well.",27,30],
    [4230,"Yeah, I know.  I wasn't feeling good today, so _____ I just ran into the shower and got down here.",30,36],
    [4231,"Have you - At one point, we were checking blood pressure fairly irregularly, have you checked it on the past -",36,42],
    [4232,"I haven't.",42,43],
    [4233,"Month or so?",43,44],
    [4234,"No.",44,45],
    [4235,"So, just _____ if you could maybe just check it once or twice sometime.",45,49],
    [4236,"Okay.",49,50],
    [4237,"Between now and the end of the month.  And if it is up for some reason, then give us a call.",50,54],
    [4238,"Okay.",54,56],
    [4239,"So, you check blood pressure at home a few times and call if - because we kinda had the same thing before where you come in here, it's pretty high and then you checked it at home, and we checked your machine and it was pretty good.  So, whatever numbers you get will be -",56,72],
    [4240,"Yeah, its, its, I know, -",72,74],
    [4241,"Not just today.",74,75],
    [4242,"- I'll be high today.",75,76],
    [4243,"Yeah.",76,77],
    [4244,"Yeah, because I was trying to handle a lot of things this morning.",77,80],
    [4245,"Sleep-wise, how have you been doing these days?",80,82],
    [4246,"Well, I was doing very good until this hour change, My God.",82,86],
    [4247,"Okay, well then, we were to, just the rest _____ .",86,89],
    [4248,"I mean, it never bothered me before when they do that.  Then all of the sudden, I don't know _____ what day it is.",89,95],
    [4249,"That's okay.  You don't need to be asked.",95,98],
    [4250,"So, pain-wise, remember before -",98,100],
    [4251,"It’s painful.",100,101],
    [4252,"Yeah.  Before you were on the gabapentin that we had used for the shingles pain, remember when you had all that herpes shingles last year?  That is a nerve pain controller drug and that's what it was designed for.",101,112],
    [4253,"What was this called?",112,114],
    [4254,"The gabapentin, Neurontin.  It's not really strong but -",114,118],
    [4255,"No.",118,120],
    [4256,"- it is what it is.  Its kind of - it's probably the best one out there for this.",120,124],
    [4257,"There is a reason, one of the reasons I quit gabapentin was because I put on weight.  I mean, immediately I start gaining and I have never liked it.  Its not",124,132],
    [4258,"Ahhh, so -",132,133],
    [4259,"And I don't try anything.",133,135],
    [4260,"Yeah.  It was probably because you don't bruise much as you used to be -",135,139],
    [4261,"That's true.",139,140],
    [4262,"But isn't that about.  There's not really any that are going to be likely to make much of the difference.",140,147],
    [4263,"Okay.",147,149],
    [4264,"That wouldn't have - although, the gabapentin for most people who tend to be weight gainer, yeah, it's a very common rather to most people.",149,156],
    [4265,"_____ like it didn't make no difference but it didn't affect this way.",156,160],
    [4266,"Right, and mostly, I mean, there are so many people who had gabapentin.  I've got, I don't know how many patients, but more than I can count who use for this, but again.",160,170],
    [4267,"Should I try it again?  I've got -",170,173],
    [4268,"I would try it.  Do you remember what dosages those were?  I'll tell you what I had sent in before.",173,179],
    [4269,"No, I don't.",179,180],
    [4270,"Probably, 300 mg, be my guest, but I'll tell you.  300 mg and I had also sent in 100 mg, but the last one I sent in were 300.  When do you notice that the foot pain is the worst?",180,192],
    [4271,"All the time.  It never, never ceases.  It wakes me up at night.",192,196],
    [4272,"And still the right side is worst than the other one?",196,199],
    [4273,"Yes, both from now but it's the right-sided toe is -",199,202],
    [4274,"With the bunion?",202,203],
    [4275,"Yeah.  That's the one that hurts the most.",203,205],
    [4276,"So that's -",205,206],
    [4277,"And then the arthritis is really starting to get _____ with the, with everything I had, I mean, my fingers are twisting, you -",206,214],
    [4278,"Um-hum.",214,215],
    [4279,"- and they hurt.  And, there's a pain right here that, I don't know what the heck it is but if it touches, that makes it real painful.",215,221],
    [4280,"Um-hum.",221,222],
    [4281,"Are they arthritis?",222,224],
    [4282,"Well, some of that is arthritis, yeah.",224,226],
    [4283,"But, you can feel the bone.",226,228],
    [4284,"Yeah.  Arthritis, these are the classic basis of being arthritis ____ .",228,232],
    [4285,"How's that?",232,234],
    [4286,"Will be through here but you get more of it -",234,237],
    [4287,"Right here.",237,238],
    [4288,"You get more of it here is it?",238,240],
    [4289,"No.  Right here.  Right, right here in this area",240,243],
    [4290,"So, that's, that's a little ganglion cyst, it's on the tendon.  So, the reason my hand closes is because I've got muscles up here that contract, closes my finger this was way, right.  So, you can almost imagine a pulley.",243,256],
    [4291,"Um-hum.",256,258],
    [4292,"Right.  And the reason that those pulleys don't spring up is because there's a bunch of little straps all the way down and those straps can have their own body fluid that comes.",258,266],
    [4293,"Good.",266,268],
    [4294,"_____  Well, in that process of being able to do that -",268,270],
    [4295,"Um-hum.",270,271],
    [4296,"- you can get a little cyst in those -",271,273],
    [4297,"Oh.",273,274],
    [4298,"_____ that is 99% probable.",274,276],
    [4299,"Right.",276,277],
    [4300,"Both can be removed surgically.  So, we could have, like a surgeon do that if it bothers you too much.",277,282],
    [4301,"Um-hum.",282,283],
    [4302,"But you don't have to.",283,284],
    [4303,"They don't mean anything.  The doctor _____.",284,287],
    [4304,"I know.  It's a last resort but I'm just kinda letting you know that, some things that you could do as need be but -",287,294],
    [4305,"Yeah.",294,295],
    [4306,"So, if it's bothering you with the things that you'd like to do, like painting or just -",295,298],
    [4307,"That's right.",298,299],
    [4308,"- the stuff around the house.",299,300],
    [4309,"Um-hum.",300,301],
    [4310,"Then, just let me know.",301,302],
    [4311,"Okay.",302,303],
    [4312,"It's a pretty minor procedure.  Had you seen any of the ortho that is in town like Johnson or Smith before?  Ring any bells?",303,312],
    [4313,"Who?",312,313],
    [4314,"Dr. Johnson or Dr. Smith, the orthopedic surgeon.",313,316],
    [4315,"Oh.  I think Dr. Smith once.",316,318],
    [4316,"So, he does those in the office.",318,320],
    [4317,"So, we could always have you go see him again and you guys can talk about that ganglion cyst.",320,325],
    [4318,"Okay.",325,327],
    [4319,"That's about an easiest procedure, that is in and out of the office like, like this.  Um, let me just put it on here I guess.  That's the right hand's, the middle finger?",327,337],
    [4320,"Um-hum.",337,338],
    [4321,"I know what you were doing when you were a youth.",338,340],
    [4322,"Oh.",340,341],
    [4323,"Using that finger too often.",341,343],
    [4324,"Not really.",343,344],
    [4325,"That's what they all say.  You have done lot, lots of stuff, played music, had kids -",344,350],
    [4326,"I bet what's why I'm -",350,351],
    [4327,"_____ make art.",351,352],
    [4328,"- trying things, just a few if I can do it and then, I'll move on to something else.  So, -",352,357],
    [4329,"That's a good thing to do.",357,359],
    [4330,"So, that's a third right flexor.  Flexor, um, probable small ganglion cyst.",359,365],
    [4331,"Like what is that?",365,367],
    [4332,"No one really knows.  They, they predicted some type of the trauma whether it's like a bang to it or just a slow progression.",367,375],
    [4333,"I noticed it last year, last, um, summer exactly.",375,379],
    [4334,"Yeah.",379,380],
    [4335,"_____ go away.",380,381],
    [4336,"The catching you mean, or the bump or both.",381,383],
    [4337,"It was when I was writer, you know.",383,385],
    [4338,"Yeah.",385,386],
    [4339,"And that's how it started.",386,387],
    [4340,"Well, if it's really interfering with the things that you'd like to do, I'd go see him sooner.",387,392],
    [4341,"Yeah.",392,393],
    [4342,"You want me to send a referral out now or do you want, ah?",393,396],
    [4343,"No.",396,397],
    [4344,"Okay.  All you need to do is give us a call.",397,399],
    [4345,"I will.",399,401],
    [4346,"So, I will say, see ortho if symptoms worsen, how does that sound?",401,404],
    [4347,"Okay.",404,406],
    [4348,"When do we get blood work done last?",406,408],
    [4349,"Well, like few months ago.",408,410],
    [4350,"Like a few months?  Or not even?",410,413],
    [4351,"I think that was in the fall, wasn't it?",413,415],
    [4352,"Last spring.",415,416],
    [4353,"I don't even remember.",416,417],
    [4354,"Yeah.  So, we will need to get lab work done, unless you had it done in the past week or something?",417,422],
    [4355,"No.",422,424],
    [4356,"It's been a year.",424,425],
    [4357,"Is that right?",425,426],
    [4358,"Yeah. So, we're not too far behind but lets get a - we will check the thyroid as well.  So, we will get some annual labs -",426,433],
    [4359,"Copy.",433,434],
    [4360,"Um, we had talked about other options for overall pain control, one would be, you know, going to that pain clinic in Woodstock.",434,442],
    [4361,"It's almost no for me.  I can't take off and go down there.",442,446],
    [4362,"Well, here's what I would do?",446,448],
    [4363,"You want me to drive that far.",448,450],
    [4364,"Right.  It might be worth just going in and sitting down … they are pain specialists, so they know more about pain management than I do.  If they come up with the great plans and I can continue with that.",450,460],
    [4365,"Okay.",460,462],
    [4366,"So, I'd like their brain.",462,463],
    [4367,"Um-hum.",463,464],
    [4368,"If I could steal their brain, I would just use it, but it would be good for them to sit down with you and say, here's where you are.  This is probably a better long-term solution based on who you are, how old you are and what you can get from them.  And then, unless it is something really, … that I cannot do, then they'll probably be happy and after that to do it for you anyway _____-",464,485],
    [4369,"PATIENT: What's his name?",485,486],
    [4370,"Peterson?",486,487],
    [4371,"Yeah, yeah.",487,488],
    [4372,"Yeah.",488,489],
    [4373,"Yeah.",488,489],
    [4374,"Dr. Peterson is a good guy.",489,491],
    [4375,"Okay.",491,492],
    [4376,"We could have you see Peterson.  Just to kind of maybe have a one-time go over everything and then you could decide if you want him to manage it -",492,499],
    [4377,"No.",499,501],
    [4378,"Or?  Okay, I mean, I'll do my best to take care of you but again, I'm only so good and I am not going to pretend.",501,508],
    [4379,"Let me think on that.",508,509],
    [4380,"Okay.",509,510],
    [4381,"I'll think on that now.",510,512],
    [4382,"I think, I think it will be good at least to sit down and say, ""Do you have a better solution than what I'm proposing"" and if he does and it sounds good to you, then I will take it over from a prescribing point of view so you don't need _____.",512,523],
    [4383,"They give shots, right?",523,524],
    [4384,"He can give shots.  So, I can even do those.  So, what if the shot helped?",524,530],
    [4385,"No.  My fear is I don't trust them when I have to, can't give me the shot to take _____.",530,535],
    [4386,"Which we can always do that but -",535,538],
    [4387,"But why would I want to have some doctors do it _____ .",538,541],
    [4388,"No.  Peterson is here all the time.",541,543],
    [4389,"Oh!  I don't agree.",543,545],
    [4390,"Yeah.  No, no.  He is a local.  So, you could have at least sit down in a brain-to-brain.",545,550],
    [4391,"Um-hum.",550,551],
    [4392,"You could see options and if he says, ""Well, it would be better if you did this, and then this combination of other pill types"" -",551,558],
    [4393,"Yeah.",558,560],
    [4394,"And then, if you thought, ""Yeah, works good"", and then, I could take it over.",560,564],
    [4395,"Um-hum.",564,565],
    [4396,"Ah, just an option, I mean -",565,566],
    [4397,"Okay.",566,567],
    [4398,"Because I want you to get out and do stuff and -",567,571],
    [4399,"I'm trying.",571,572],
    [4400,"- if there's somebody who can help you and do that better than I can, then, I'd say, go for it.  So, think about it in the back of your mind because there's other pain clinic in Woodstock as well that we had talked about.  Um, so, let say Peterson??  At least for a consultation as we call it.",572,589],
    [4401,"I don't wanna make appointment with him _____, so that is canceled too.",589,593],
    [4402,"I know it.  Well, when you're ready - So, any other questions or things we need to think about for today?",593,599],
    [4403,"No, I don't have any.",599,601],
    [4404,"Okay.  Do you need refills on any meds?",601,603],
    [4405,"Not right now.",603,605],
    [4406,"Okay.  Well, let me know if you do.",605,607],
    [4407,"I probably got long enough for another month.",607,609],
    [4408,"Okay.",609,610],
    [4409,"I'll call you.",610,611],
    [4410,"Okay.  And then, let me know, if you wouldn't mind, if your blood pressure is high at home, then please give me a call.",611,615],
    [4411,"Okay.  I will.",615,617],
    [4412,"And just give me a heads-up.",617,618],
    [4413,"um.",618,620],
    [4414,"So, the big thing I'd like to get done before now and the next time we get together would be drawing the labs.",620,624],
    [4415,"Okay.",624,626],
    [4416,"So, those you should do fasting like you've done before but you can drink lots of water.",626,630],
    [4417,"Okay.  That's for, what, 12 hours?",630,633],
    [4418,"Yeah.  That would be perfect.  all right.  Remember this we have lungs?",633,637],
    [4419,"Yeah.",637,638],
    [4420,"Heart sounds good.  Let me have you - when you're ready, a big deep breath in and out of your mouth.",638,644],
    [4421,"[Breathing in]",644,646],
    [4422,"Yes.",646,647],
    [4423,"[Breathing out]",647,648],
    [4424,"Yes.",648,649]
  ]
end

def tags
  # utterance_id, tag_type_id
  [
    [4216,6],
    [4222,2],
    [4235,5],
    [4245,6],
    [4252,2],
    [4290,3],
    [4300,8],
    [4346,5],
    [4354,5],
    [4360,8],
    [3280,6],
    [3282,7],
    [3291,3],
    [3293,2],
    [3297,3],
    [3303,2],
    [3307,2],
    [3307,6],
    [3323,6],
    [3324,5],
    [3325,6],
    [3332,3],
    [3338,7],
    [3342,6],
    [3350,5],
    [3352,3],
    [3354,7],
    [3355,4],
    [3360,6],
    [3369,3],
    [3369,5],
    [4223,2],
    [4225,2],
    [4226,2],
    [4229,7],
    [4230,6],
    [4237,5],
    [4239,5],
    [4239,7],
    [4251,6],
    [4252,3],
    [4257,6],
    [4257,2],
    [4262,3],
    [4264,3],
    [4265,6],
    [4266,2],
    [4270,2],
    [4270,6],
    [4282,1],
    [4290,1],
    [4306,8],
    [4317,5],
    [4319,3],
    [4330,1],
    [4332,3],
    [4333,6],
    [4364,5],
    [4376,8],
    [4382,8],
    [4392,8],
    [4410,5],
    [4414,5],
    [3285,2]
  ]
end

def links
  [[
  '0:09',
  'Norco ',
  'https://medlineplus.gov/druginfo/meds/a601006.html',
  4222
  ],[
  '0:14',
  'Gabapentin',
  'https://medlineplus.gov/druginfo/meds/a694007.html',
  4222
  ],[
  '0:17',
  'Tramadol',
  'https://medlineplus.gov/druginfo/meds/a695011.html',
  4222
  ],[
  '0:27',
  'high blood pressure',
  'https://medlineplus.gov/highbloodpressure.html',
  4229
  ],[
  '1:41',
  'Gabapentin',
  'https://medlineplus.gov/druginfo/meds/a694007.html',
  4252
  ],[
  '1:41',
  'shingles',
  'https://medlineplus.gov/shingles.html',
  4252
  ],[
  '1:54',
  'Gabapentin',
  'https://medlineplus.gov/druginfo/meds/a694007.html',
  ],[
  '1:41',
  'Gabapentin',
  'https://medlineplus.gov/druginfo/meds/a694007.html',
  ],[
  '2:04',
  'Gabapentin',
  'https://medlineplus.gov/druginfo/meds/a694007.html',
  4257
  ],[
  '2:29',
  'Gabapentin',
  'https://medlineplus.gov/druginfo/meds/a694007.html',
  4262
  ],[
  '2:40',
  'Gabapentin',
  'https://medlineplus.gov/druginfo/meds/a694007.html',
  4266
  ],[
  '3:00',
  'foot pain',
  'https://medlineplus.gov/ency/article/003183.htm',
  4270
  ],[
  '3:22',
  'bunion',
  'https://medlineplus.gov/ency/article/001231.htm',
  4270
  ],[
  '3:26',
  'arthritis',
  'https://medlineplus.gov/arthritis.html',
  4270
  ],[
  '3:44',
  'arthritis',
  'https://medlineplus.gov/arthritis.html',
  4282
  ],[
  '4:03',
  'ganglion cyst',
  'https://www.assh.org/handcare/hand-arm-conditions/ganglion-cyst',
  4290
  ],[
  '5:20',
  'ganglion cyst',
  'https://www.assh.org/handcare/hand-arm-conditions/ganglion-cyst',
  4317
  ],[
  '5:59',
  'ganglion cyst',
  'https://www.assh.org/handcare/hand-arm-conditions/ganglion-cyst',
  4330
  ],[
  '6:57',
  'blood count test',
  'https://medlineplus.gov/bloodcounttests.html',
  4346
  ],[
  '7:14',
  'pain management',
  'http://www.asahq.org/whensecondscount/pain-management/',
  4360
  ],[
  '7:30',
  'pain management',
  'http://www.asahq.org/whensecondscount/pain-management/',
  4364
  ],[
  '10:11',
  'blood pressure measurement',
  'https://medlineplus.gov/ency/article/007490.htm',
  4410
  ]]
end
