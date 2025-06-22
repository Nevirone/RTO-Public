class Main
{
# Base Expedition
Description = "Xtreme Expedition! Explore what lies beyond the walls!";
TrainingMode = false;
StartTitansAmount = 45;
DifficultyMultiplier = 1.0;
SuppliesPerWagon = 40;
TitanBaseDamage = 100;
TitanDamageChange = 50;
AmmoPerWagon = 100;
DayDuration = 360.0;
NightDuration = 180.0;
StartWithGas = true;
SkillBan = true;
FirstPerson = false;
AllowOneWingWin = false;
AllowOneWingWinTooltip = "Allow win on capturing last zone with not every zone captured";
AllowAnnieSurviveWin = true;
AllowAnnieSurviveWinTooltip = "Allow win when Annie is still alive";

EnableHumanAllChat = false;
EnableHumanAllChatTooltip = "If enabled, humans can use All chat.";
HumanChatProximity = 400.0;
HumanChatProximityTooltip = "Distance for humans to see allied text chat in Proximity mode.";
OutlineRange = 300.0;
OutlineRangeTooltip = "Distance for humans to see other humans outlined";

HumanInteractionDistance = 5.0;
PushForce = 10.0;

LeftReinforcementsEnabled = true;
RightReinforcementsEnabled = true;

PermanentRank = false;
PermanentRankTooltip = "If enabled Rank cannot be switched in game";

MedicLimit = 6;
MedicLimitTooltip = "How many medics are allowed in formation";
MedicHealCooldown = 5.0;
MedicBandages = 3;
MedicHealAmount = 100;
MedicBandagesTooltip = "Number of bandages medics get";

EngineerLimit = 4;
EngineerResources = 2000;
EngineerFixCooldown = 5.0;
EngineerFixRange = 10.0;

ErenTransformations = 4;
ErenTransformationCooldown = 30.0;
ErenTransformationLength = 120.0;
ErenHealth = 3500;

EnableAnnie = false;
EnableAIShifterTooltip = "If enabled, Annie will spawn at a random capture point between Farm and Explore what lies Beyond the Walls.";
AnnieHealth = 1000;
AnnieHealthTooltip = "AI Annie's health";

ShifterExplosionForce = 50.0;
ShifterExplosionDamage = 300.0;
ShifterForceRange = 240.0;
ShifterDamageRange = 120.0;

# Other
_hasSpawned = false;
_outlineMode = 2;
_hideHUD = false;

_healCooldown = 0;
_fixCooldown = 0;
_resourcesUsed = 0;
_bandagesUsedCounter = 0;
_erenCooldown = 0;
_erenTransformationCounter = 0;
_pushCooldown = 0;
_closestRepairable = null;
_closestRepairableDistance = null;
_closestHuman = null;
_closestHumanDistance = null;
_closestHumanStats = null;
_lastPointCaptured = false;
_annie = null;

# Day Cycle
_timeCounter = 0;
_timeOfDay = "Night";

# Capture Zones
_capturedZoneCount = 0;
_allZoneCount = 0;
_currentPhase = 0;

# Chat
_chatModeIndex = 0;
_chatModeList = List();

# Weapon switching
_bladeDurability = 200;
_bladesLeft = 10;
_gasLeft = 0;
_roundsLeft = 2;
_spearsLeft = 2;
_selectedSpecial = "Escape";
_currentSpecial = "Escape";

# Reinforcements
_leftReinforcementsSpawn = Vector3(-4774,99,3570);
_rightReinforcementsSpawn = Vector3(-457,10,4000);

# Object Lists
_captureZones = List();
_captureZoneComponenets = List();
_wagons = List();
_gateList = List();
_castleRuinsList = List();
_forestList = List();
_undergroundList = List();
_leftRiverList = List();
_rightRiverList = List();
_rumblingActivate = List();
_rumblingDeactivate = List();
_spawnerComponentList = List();
_repairableObjectList = List();
_musicObjectList = List();
_zonesActivated = List();

# Day Titan Settings
_DayTitanDetectRange = 1300;
_DayTitanFocusRange = 100;
_DayTitanFocusTime = 5;
_DayTitanRunSpeedBase = 22;
_DayTitanWalkSpeedBase = 20;
_DayTitanRunSpeedPerLevel = 12;
_DayTitanWalkSpeedPerLevel = 10;
_DayTitanTurnSpeed = 3.0;
_DayTitanRotateSpeed = 4.0;
_DayTitanJumpForce = 140;
_DayTitanAttackSpeed = 1.5;
_DayTitanAttackWait = 0.01;
_DayTitanActionPause = 0.15;
_DayTitanAttackPause = 0.1;
_DayTitanTurnPause = 0.05;

# Night Titan Settings
_NightTitanDetectRange = 400;
_NightTitanFocusRange = 50;
_NightTitanFocusTime = 2;
_NightTitanRunSpeedBase = 14;
_NightTitanWalkSpeedBase = 12;
_NightTitanRunSpeedPerLevel = 8;
_NightTitanWalkSpeedPerLevel = 6;
_NightTitanTurnSpeed = 2.7;
_NightTitanRotateSpeed = 2.2;
_NightTitanJumpForce = 70;
_NightTitanAttackSpeed = 1.22;
_NightTitanAttackWait = 0.19;
_NightTitanActionPause = 0.2;
_NightTitanAttackPause = 0.2;
_NightTitanTurnPause = 0.1;

_titanCustomSizeEnabled = false;
_titanSizeAverage = 0;
_titanSizeDifference = 0;

# Game Events

function Init()
{
Game.DefaultShowKillFeed = false;
Game.ShowScoreboardLoadout = false;
Game.ShowScoreboardStatus = false;
if (Network.IsMasterClient) { Game.ShowScoreboardStatus = true; }

self.SetInitialSettings();

self._chatModeList.Add(ChatTypeEnum.Proximity);
self._chatModeList.Add(ChatTypeEnum.Squad);
self._chatModeList.Add(ChatTypeEnum.Formation);
self._chatModeList.Add(ChatTypeEnum.Officer);
if (self.EnableHumanAllChat) { self._chatModeList.Add(ChatTypeEnum.All); }

minSize = Game.GetTitanSetting(SettingNames.TitanSizeMin);
maxSize = Game.GetTitanSetting(SettingNames.TitanSizeMax);
self._titanCustomSizeEnabled = Game.GetTitanSetting(SettingNames.TitanSizeEnabled);
self._titanSizeAverage = (maxSize + minSize) / 2.0;
self._titanSizeDifference = (maxSize - minSize) / 2.0;
}

function OnGameStart()
{
self.PrepareUI();
if (!self.TrainingMode) { self.PrintStartMessages(); }
self.FindMapObjects();

if (Network.IsMasterClient)
{
Game.SpawnTitansAsync("Default", self.StartTitansAmount);
if(self.EnableAnnie) 
{ 
if (self.TrainingMode) { self._annie = Game.SpawnShifter("Annie"); }
else { self._annie = Game.SpawnShifterAt("Annie", Vector3(-2240, 200, 1400)); }
self._annie.Health = self.AnnieHealth;
self._annie.MaxHealth = self.AnnieHealth;
self._annie.DetectRange = 2000;
}
self.SetDifficulty();
self.SetWagonSupplies();
self.SetCannonWagonAmmo();
}

self.SetObjectives();
}

function OnFrame()
{
self.CheckInputs();
}

function OnTick()
{
myPlayer = Network.MyPlayer;
myCharacter = Network.MyPlayer.Character;

self.TimersOnTick();

if (myCharacter != null && myCharacter.Type == "Human" && myCharacter.Weapon == "Thunderspear" && myCharacter.State == "Refill") { myCharacter.MaxAmmoTotal = 4; }
}

function OnSecond()
{
myCharacter = Network.MyPlayer.Character;
myPlayer = Network.MyPlayer;
rank = myPlayer.GetCustomProperty(NamesEnum.Rank);

self.FindClosestHuman();
self.FindClosestRepairable();
self.OutlineHumans();
self.ProcessCaptureZones();
self.SetBottomLabel();

if(myCharacter != null)
{
if(self.FirstPerson && myCharacter.Type == "Human") { Camera.FollowDistance = 0.0; }
elif(self.FirstPerson && myCharacter.Type == "Shifter") { Camera.FollowDistance = 1.00; }
}

if (rank == RanksEnum.Eren || rank == RanksEnum.Medic || rank == RanksEnum.Engineer) { self.SetLegend(); }

if (Network.IsMasterClient && !Game.IsEnding)
{
titans = Game.Titans.Count;
humans = Game.Humans.Count;
playerShifters = Game.PlayerShifters.Count;

if (self.TrainingMode && Game.Titans.Count < self.StartTitansAmount)
{
Game.SpawnTitan("Default");
}

if (humans > 0)
{
self._hasSpawned = true;
}
elif (!self.TrainingMode && humans == 0 && playerShifters == 0 && self._hasSpawned)
{
text = "All " + self.GetStringColorWrapped("SCOUTS", "Scout") + " are dead, Humanity Has Failed!";
UI.SetLabelAll("MiddleCenter", text);
Game.End(20.0);
return;
}

UI.SetLabelAll("BottomRight", "[" + self.GetStringColorWrapped("CAPTURED ZONES", "Zone") + ":" +
Convert.ToString(self._capturedZoneCount) + "/" + Convert.ToString(self._allZoneCount) + "]");
}
}

# Spawn, Death and Reload

function OnPlayerSpawn(player, character)
{
if(player == Network.MyPlayer && character.Type == "Human")
{
formation = player.GetCustomProperty(NamesEnum.Formation);
squad = player.GetCustomProperty(NamesEnum.Squad);
rank = player.GetCustomProperty(NamesEnum.Rank);

self.SetChatLabel();

if(!self.StartWithGas)
{
character.CurrentGas = 0;
character.CurrentBlade = 0;
character.CurrentBladeDurability = 0;
}

if(formation == NamesEnum.NA) { UI.ShowPopup("FormationPopup"); }
elif (squad == NamesEnum.NA) { UI.ShowPopup("SquadPopup"); }
elif (rank == NamesEnum.NA) { UI.ShowPopup("RankPopup"); }

self.SetRankHealth(character);
}
}

function OnCharacterSpawn(character)
{
myCharacter = Network.MyPlayer.Character;
if (character.Type == "Titan")
{
if (character.IsCrawler) { character.Size = Math.Min(character.Size, 2.0); }
if (self._titanCustomSizeEnabled) { self.ApplyTitanDamage(character); }
self.ApplyTitanSettings(character);
}
elif (character.Type == "Shifter")
{
if (character.IsAI) { self.SetObjectives(); }
elif (character.IsMainCharacter)
{
self._erenTransformationCounter = self._erenTransformationCounter + 1;
self._erenCooldown = self.ErenTransformationCooldown;
self.SetLegend();

character.MaxHealth = self.ErenHealth;
character.Health = self.ErenHealth;
character.CustomDamageEnabled = true;
character.CustomDamage = 200;
character.AttackSpeedMultiplier = 1.5;
}

if (myCharacter != null && myCharacter != character)
{
distance = Vector3.Distance(myCharacter.Position, character.Position);
explosionForce = 50.0;
explosionDamage = 300.0;
explosionMaxRange = 240.0;
damageMaxRange = 120.0;

if (distance < self.ShifterForceRange)
{
scale = 1;
if (distance > (self.ShifterForceRange / 2)) { scale -= (distance - (self.ShifterForceRange / 2)) / (self.ShifterForceRange / 2); }
direction = myCharacter.Position - character.Position;
direction.Y = 0;
myCharacter.AddForce(direction.Normalized * self.ShifterExplosionForce + Vector3.Up * self.ShifterExplosionForce / 5, "Impulse");

if (distance < self.ShifterDamageRange)
{
scale = 1;
if (distance > (self.ShifterDamageRange / 2)) { scale -= (distance - (self.ShifterDamageRange / 2)) / (self.ShifterDamageRange / 2); }
myCharacter.GetDamaged("Impact", self.ShifterExplosionDamage * scale);
}
}
}
}
}

function OnCharacterReloaded(character)
{
if (character.Type == "Human" && character.Player == Network.MyPlayer)
{
self.SetRankWeapon(character);
if (character.Weapon == "Thunderspear")
{
character.MaxAmmoRound = 2;
character.CurrentAmmoRound = self._roundsLeft;
character.MaxAmmoTotal = self._spearsLeft;
character.CurrentAmmoLeft = self._spearsLeft;
}
elif (character.Weapon == "Blade")
{
character.CurrentBladeDurability = self._bladeDurability;
character.CurrentBlade = self._bladesLeft;
}
self.CheckSkillBan();

if (Network.MyPlayer.GetCustomProperty(NamesEnum.Rank) == RanksEnum.Eren)
{
if (character.CurrentSpecial != "Eren") { self._selectedSpecial = character.CurrentSpecial; }
else { character.SetSpecial(self._selectedSpecial); }
}
}
}

function OnCharacterDamaged(victim, killer, killerName, damage)
{
if (victim.Type == "Human" )
{
if (Network.MyPlayer.Character != null && Network.MyPlayer.Character == victim)
{
self.SetBottomLabel();
Game.SpawnEffect("Blood1", victim.Position, Vector3.Zero, 3);
victim.PlaySound("CrashLand");
}
}
elif (victim.Type == "Shifter")
{
self.SetObjectives();
}
}

function OnCharacterDie(victim, killer, killerName)
{
if (victim.IsMainCharacter)
{
self.SetChatLabel();
}

if (victim.IsAI) { return; }

if (Network.IsMasterClient && killerName == "")
{
killerName = UI.WrapStyleTag("KEYBOARD", "color", "Red");
Game.ShowKillFeedAll(killerName, victim.Name, 1000, "Blade");
}
}

# Network, Chat and Button

function OnNetworkMessage(sender, message)
{
messageSplit = String.Split(message, " ");
myCharacter = Network.MyPlayer.Character;
myPlayer = Network.MyPlayer;
myCharacter = Network.MyPlayer.Character;

if(String.StartsWith(message, "{")) # Chat message
{
msgDict = Json.LoadFromString(message);
message = msgDict.Get("message");
if(message == "chat") { Game.Print(msgDict.Get("chat")); }
return;
}
elif (String.StartsWith(message, "@")) # Messages from ZoneTrigger component
{
self.ZoneTriggerMessage(String.Substring(message, 1));
return;
}
elif(message == "rumble")
{
self.StartRumbling();
}
# Messages from rank change
elif (message == "Dismiss")
{
myPlayer.SetCustomProperty(NamesEnum.Rank, NamesEnum.NA);
self.SetRankHealth(myCharacter);
self.SetLegend();
self.UpdateSquadRank();
Network.SendMessageOthers("UpdateLegend");
UI.SetLabelForTime("MiddleCenter", "You were stripped of your rank", 2.0);
Game.Print("You were stripped of your rank");
}
elif (message == "UpdateLegend")
{
self.SetLegend();
if (UI.IsPopupActive("Formation")) { self.SetFormationContent(); }
}
# Functions messages
elif (message == "ErenUnshift" && Network.IsMasterClient && sender.Character != null && sender.Character.Type == "Shifter")
{
character = sender.Character;
position = character.NapePosition;
character.GetKilled("Unshift");
Game.SpawnPlayerAt(character.Player, true, position);
}
elif (message == "StatsRequest" && myCharacter != null)
{
currentGas = Convert.ToString(myCharacter.CurrentGas);
maxGas = Convert.ToString(myCharacter.MaxGas);

Network.SendMessage(sender, "StatsResponse " + currentGas + " " + maxGas);
}
elif (messageSplit.Get(0) == "StatsResponse" && myCharacter != null)
{
currentGas = Convert.ToFloat(messageSplit.Get(1));
maxGas = Convert.ToFloat(messageSplit.Get(2));

self._closestHumanStats = PlayerStats(sender, currentGas, maxGas);
}
elif (message == "HealRequest" && myCharacter != null)
{
myCharacter.Health = Math.Min(myCharacter.Health + self.MedicHealAmount, myCharacter.MaxHealth);
Network.SendMessage(sender, "HealAccept");
UI.SetLabelForTime("MiddleCenter", "You have been healed by " + sender.Name, 2.0);
myCharacter.Emote("Eat");
}
elif (message == "HealAccept" && myCharacter != null)
{
UI.SetLabelForTime("MiddleCenter", sender.Name + " has been healed.", 2.0);
self._bandagesUsedCounter += 1;
self.SetLegend();
myCharacter.Emote("Wave");
}
elif(message == "AddForce" && myCharacter != null)
{
self.AddForce(sender.Character);
}
elif(message == "ShareGas" && myCharacter != null && myCharacter.MaxGas - myCharacter.CurrentGas >= 10)
{
myCharacter.CurrentGas = Math.Min(myCharacter.CurrentGas + 10, myCharacter.MaxGas);
Network.SendMessage(sender, "ShareGasAccept");
myCharacter.PlayAnimation("Armature|resupply");
myCharacter.PlayAnimation("Refill ");
UI.SetLabelForTime("MiddleCenter", "Recieved gas from " + sender.Name, 2.0);
self._closestHumanStats = null;
}
elif (message == "ShareGasAccept" && myCharacter != null)
{
myCharacter.CurrentGas = Math.Max(myCharacter.CurrentGas - 10, 0);
myCharacter.PlayAnimation("Armature|resupply");
myCharacter.PlayAnimation("Refill ");
UI.SetLabelForTime("MiddleCenter", "Gave gas to " + sender.Name, 2.0);
}
}

function OnChatInput(message)
{
myCharacter = Network.MyPlayer.Character;
myrank = Network.MyPlayer.GetCustomProperty(NamesEnum.Rank);
mysquad = Network.MyPlayer.GetCustomProperty(NamesEnum.Squad);
myformation = Network.MyPlayer.GetCustomProperty(NamesEnum.Formation);

if(!String.StartsWith(message,"/")){
chatMode = self.GetChatMode();

chatMsg = self.FormatChatMessage(message, chatMode);

msgDict = Dict();
msgDict.Set("message", "chat");
msgDict.Set("chat", chatMsg);
netMsg = Json.SaveToString(msgDict);
for(player in Network.Players){
playerRank = player.GetCustomProperty(NamesEnum.Rank);
playerSquad = player.GetCustomProperty(NamesEnum.Squad);
playerFormation = player.GetCustomProperty(NamesEnum.Formation);

if(player == Network.MyPlayer)
{
Game.Print(chatMsg);
}
elif(player.Character == null)
{
Network.SendMessage(player, netMsg);
}
elif(chatMode == ChatTypeEnum.All)
{
Network.SendMessage(player, netMsg);
}
elif(chatMode == ChatTypeEnum.Proximity && Vector3.Distance(player.Character.Position, myCharacter.Position) < self.HumanChatProximity)
{
Network.SendMessage(player, netMsg);
}
elif(chatMode == ChatTypeEnum.Squad && mysquad == playerSquad && myformation == playerFormation)
{
Network.SendMessage(player, netMsg);
}
elif(chatMode == ChatTypeEnum.Formation && myformation == playerFormation)
{
Network.SendMessage(player, netMsg);
}
elif(chatMode == ChatTypeEnum.Officer)
{
Network.SendMessage(player, netMsg);
}
}
return false;
}
else
{
messageSplit = String.Split(message, " ");
if (String.StartsWith(message, "/dismiss") && messageSplit.Count == 2 && (Network.IsMasterClient || myrank == RanksEnum.Commander || myrank == RanksEnum.SectionCommander))
{
id = Convert.ToInt(messageSplit.Get(1));
for (player in Network.Players) { 
if (player.ID == id) 
{ 
playerFormation = player.GetCustomProperty(NamesEnum.Formation);
playerSquad = player.GetCustomProperty(NamesEnum.Squad);
if (myrank == RanksEnum.SectionCommander && (myformation != playerFormation || mysquad != playerSquad))
{
Game.Print("Can't dismiss soldier. This soldier is not under your command!");
return false;
}
Network.SendMessage(player, "Dismiss");
Game.Print(player.Name + " dismissed!");
return false;
}
}
Game.Print("Player with given id not found");
return false;
}
elif (Network.IsMasterClient) 
{
if (messageSplit.Get(0) == "/difficulty" && messageSplit.Count == 2)
{
difficulty = Convert.ToFloat(messageSplit.Get(1));
self.DifficultyMultiplier = difficulty; 
self.SetDifficulty();
Game.Print("Current difficulty: " + self.DifficultyMultiplier);
return false;
}
elif (messageSplit.Get(0) == "/tpid" && messageSplit.Count == 3 && myCharacter != null)
{
id = Convert.ToInt(messageSplit.Get(1));
heightOffset = Convert.ToInt(messageSplit.Get(2));
object = Map.FindMapObjectByID(id);
if(object != null) { Network.MyPlayer.Character.Transform.Position = object.Position + Vector3.Up * heightOffset; }
return false;
}
elif (messageSplit.Get(0) == "/tpname" && messageSplit.Count == 3 && myCharacter != null)
{
heightOffset = Convert.ToInt(messageSplit.Get(2));
object = Map.FindMapObjectByName(messageSplit.Get(1));
if(object != null) { Network.MyPlayer.Character.Transform.Position = object.Position + Vector3.Up * heightOffset; }
return false;
}
elif (messageSplit.Get(0) == "/tpobject" && messageSplit.Count == 3 && myCharacter != null)
{
object = Map.FindMapObjectByID(Convert.ToInt(messageSplit.Get(1)));
heightOffset = Convert.ToInt(messageSplit.Get(2));
if(object != null) { object.Position = myCharacter.Position + Vector3.Up * heightOffset; }
return false;
}
elif (messageSplit.Get(0) == "/fixobject" && messageSplit.Count == 3)
{
object = Map.FindMapObjectByID(Convert.ToInt(messageSplit.Get(1)));
health = Convert.ToInt(messageSplit.Get(2));
if(object != null) 
{ 
destroyableComp = object.GetComponent("DestroyableObject");
if (destroyableComp != null) { destroyableComp.SetHealth(health); }
}
return false;
}
elif (message == "/rumble")
{
Network.SendMessageOthers("rumble");
self.StartRumbling();
return false;
}
elif (messageSplit.Get(0) == "/tpto" && messageSplit.Count == 2 && myCharacter != null)
{
id = Convert.ToInt(messageSplit.Get(1));
for (human in Game.Humans) { if (human.Player.ID == id) { myCharacter.Transform.Position = human.Transform.Position; }}
return false;
}
elif (messageSplit.Get(0) == "/tp" && messageSplit.Count == 2 && myCharacter != null)
{
id = Convert.ToInt(messageSplit.Get(1));
for (player in Network.Players) { if (player.ID == id && player != Network.MyPlayer) { Game.SpawnPlayerAt(player, true, myCharacter.Position); }}
return false;
}
elif (message == "/tpall" && myCharacter != null)
{
for (player in Network.Players) { if (player != Network.MyPlayer) { Game.SpawnPlayerAt(player, true, myCharacter.Position); }}
return false;
}
elif (message == "/killtitans")
{  
for (titan in Game.Titans){
titan.GetKilled("Server");
}
return false;
}
elif (message == "/hosthelp")
{
message = "Commands available: " + String.Newline;
message += "/difficulty [value] - set difficulty value" + String.Newline;
message += "/tpid [id] [height] - tp above object with given id offset by given height" + String.Newline;
message += "/tpname [name] [height] - tp above object with given name offset by given height" + String.Newline;
message += "/rumble - starts rumbling event" + String.Newline;
message += "/tpto [id] - tp to player with given id" + String.Newline;
message += "/tp [id] - tp player with given id at my position" + String.Newline;
message += "/tpall - tp all players at my position" + String.Newline;
message += "/killtitans - kill all titans";
Game.Print(message);
return false;
}
}
}
return true;
}

function OnButtonClick(buttonName)
{
myPlayer = Network.MyPlayer;
myCharacter = Network.MyPlayer.Character;
if(buttonName == "Settings")
{
UI.ShowPopup("Settings");
}
elif (buttonName == "SquadButton")
{
if (self._capturedZoneCount == 0)
{
myPlayer.SetCustomProperty(NamesEnum.Formation, NamesEnum.NA);
myPlayer.SetCustomProperty(NamesEnum.Squad, NamesEnum.NA);
if (self.PermanentRank) { Game.Print("Rank swiching is disabled"); }
elif (myCharacter == null) { Game.Print("You need to be alive to switch Rank"); }
else {
myPlayer.SetCustomProperty(NamesEnum.Rank, NamesEnum.NA);
self.CheckSkillBan();
}
}

UI.HidePopup("GameGuide");

f = myPlayer.GetCustomProperty(NamesEnum.Formation);
s = myPlayer.GetCustomProperty(NamesEnum.Squad);
r = myPlayer.GetCustomProperty(NamesEnum.Rank);

if(f == NamesEnum.NA) { UI.ShowPopup("FormationPopup"); }
elif (s == NamesEnum.NA) { UI.ShowPopup("SquadPopup"); }
elif (r == NamesEnum.NA) { UI.ShowPopup("RankPopup"); }
else { UI.SetLabelForTime("MiddleCenter", "Too late to switch squad", 1.5); }

if (self._chatModeIndex == 3) 
{ 
self._chatModeIndex = 0; 
self.SetChatLabel();
}
}
elif(buttonName == "FormationButton")
{
self.SetFormationContent();
UI.ShowPopup("Formation");
UI.HidePopup("GameGuide");
}
elif(buttonName == "SelfOutline")
{
RoomData.SetProperty(PropertyEnum.SelfOutline, !RoomData.GetProperty(PropertyEnum.SelfOutline, true));
self.SetSettingsContent();
}
elif(buttonName == "KeyGuide")
{
RoomData.SetProperty(PropertyEnum.KeyGuide, !RoomData.GetProperty(PropertyEnum.KeyGuide, true));
self.SetLegend();
self.SetSettingsContent();
}
elif(buttonName == "FlareGuide")
{
RoomData.SetProperty(PropertyEnum.FlareGuide, !RoomData.GetProperty(PropertyEnum.FlareGuide, false));
self.SetLegend();
self.SetSettingsContent();
}
elif(buttonName == "MusicToggle")
{
RoomData.SetProperty(PropertyEnum.MusicToggle, !RoomData.GetProperty(PropertyEnum.MusicToggle, true));
self.SetSettingsContent();
}

if (buttonName == "ChooseLeft")
{
myPlayer.SetCustomProperty(NamesEnum.Formation, FormationsEnum.Left);
UI.HidePopup("FormationPopup");
UI.ShowPopup("SquadPopup");
}
elif (buttonName == "ChooseRight")
{
myPlayer.SetCustomProperty(NamesEnum.Formation, FormationsEnum.Right);
UI.HidePopup("FormationPopup");
UI.ShowPopup("SquadPopup");
}

if (myPlayer.GetCustomProperty(NamesEnum.Squad) == NamesEnum.NA)
{
if (buttonName == "JoinRecon"){
myPlayer.SetCustomProperty(NamesEnum.Squad, SquadsEnum.Recon);
Game.Print("You joined the Recon Squad.");
UI.HidePopup("SquadPopup");
self.SetObjectives();
if (myPlayer.GetCustomProperty(NamesEnum.Rank) == NamesEnum.NA) { UI.ShowPopup("RankPopup"); }
}
elif (buttonName == "JoinRear"){
myPlayer.SetCustomProperty(NamesEnum.Squad, SquadsEnum.RearGuard);
Game.Print("You joined the Rear Guard Squad.");
UI.HidePopup("SquadPopup");
self.SetObjectives();
if (myPlayer.GetCustomProperty(NamesEnum.Rank) == NamesEnum.NA) { UI.ShowPopup("RankPopup"); }
}
elif (buttonName == "JoinSupply"){
myPlayer.SetCustomProperty(NamesEnum.Squad, SquadsEnum.SupplyGuard);
Game.Print("You joined the Supply Guard Squad.");
UI.HidePopup("SquadPopup");
self.SetObjectives();
if (myPlayer.GetCustomProperty(NamesEnum.Rank) == NamesEnum.NA) { UI.ShowPopup("RankPopup"); }
}
}

if (myPlayer.GetCustomProperty(NamesEnum.Rank) == NamesEnum.NA)
{
if (buttonName == "ChooseCommander"){
formation = myPlayer.GetCustomProperty(NamesEnum.Formation);
if (formation != NamesEnum.NA){
for (p in Network.Players){
if (p.GetCustomProperty(NamesEnum.Rank) == RanksEnum.Commander && p.GetCustomProperty(NamesEnum.Formation) == formation){
Game.Print("A Commander already exists in your formation.");
myPlayer.SetCustomProperty(NamesEnum.Rank, NamesEnum.NA);
return;
}
}
myPlayer.SetCustomProperty(NamesEnum.Rank, RanksEnum.Commander);
Game.Print("You are now the Commander of " + formation + ".");
UI.HidePopup("RankPopup");
}
}
elif (buttonName == "ChooseSectionCommander")
{
squad = myPlayer.GetCustomProperty(NamesEnum.Squad);
formation = myPlayer.GetCustomProperty(NamesEnum.Formation);
if (formation == NamesEnum.NA || squad == NamesEnum.NA) { return; }

for (p in Network.Players)
{
if (p.GetCustomProperty(NamesEnum.Rank) == RanksEnum.SectionCommander && p.GetCustomProperty(NamesEnum.Formation) == formation && p.GetCustomProperty(NamesEnum.Squad) == squad)
{
Game.Print("This squad already has a Section Commander.");
return;
}
}
myPlayer.SetCustomProperty(NamesEnum.Rank, RanksEnum.SectionCommander);
Game.Print("You are now the Section Commander for " + squad + " in " + formation + ".");
UI.HidePopup("RankPopup");
}
elif(buttonName == "ChooseEren")
{
for (p in Network.Players){
if (p.GetCustomProperty(NamesEnum.Rank) == RanksEnum.Eren){
Game.Print("Eren has already been chosen.");
return;
}
}
myPlayer.SetCustomProperty(NamesEnum.Rank, RanksEnum.Eren);
self._erenTransformationCounter = 0;
Game.Print("You chose rank: Eren.");
UI.HidePopup("RankPopup");
}
elif (buttonName == "ChooseMedic")
{
medicCount = 0;
for (p in Network.Players)
{
if (p.GetCustomProperty(NamesEnum.Rank) == RanksEnum.Medic) { medicCount += 1; }
}

if (medicCount >= self.MedicLimit) 
{
Game.Print("Medic amount limit reached.");
return;
}

myPlayer.SetCustomProperty(NamesEnum.Rank, RanksEnum.Medic);
self._bandagesUsedCounter = 0;
Game.Print("You chose rank: Medic.");
UI.HidePopup("RankPopup");
}
elif (buttonName == "ChooseEngineer")
{
engineerCount = 0;
for (p in Network.Players)
{
if (p.GetCustomProperty(NamesEnum.Rank) == RanksEnum.Engineer) { engineerCount += 1; }
}

if (engineerCount >= self.EngineerLimit) 
{
Game.Print("Engineer amount limit reached.");
return;
}

myPlayer.SetCustomProperty(NamesEnum.Rank, RanksEnum.Engineer);
self._resourcesUsed = 0;
Game.Print("You chose rank: Engineer.");
UI.HidePopup("RankPopup");
}
elif (buttonName == "ChooseCommunicationOfficer"){
formation = myPlayer.GetCustomProperty(NamesEnum.Formation);
if (formation == NamesEnum.NA) { return; }

for (p in Network.Players)
{
if (p.GetCustomProperty(NamesEnum.Rank) == RanksEnum.CommunicationOfficer && p.GetCustomProperty(NamesEnum.Formation) == formation)
{
Game.Print("This formation already has a Communication Officer.");
return;
}
}
myPlayer.SetCustomProperty(NamesEnum.Rank, RanksEnum.CommunicationOfficer);
Game.Print("You chose rank: Communication Officer.");
UI.HidePopup("RankPopup");
}
elif (buttonName == "ChoosePrivate"){
myPlayer.SetCustomProperty(NamesEnum.Rank, RanksEnum.Private);
Game.Print("You chose rank: Private.");
UI.HidePopup("RankPopup");
}
elif (buttonName == "ChooseCadet"){
myPlayer.SetCustomProperty(NamesEnum.Rank, RanksEnum.Cadet);
Game.Print("You chose rank: Cadet.");
UI.HidePopup("RankPopup");
}
}

self.SetRankWeapon(myCharacter);
self.SetRankHealth(myCharacter);
self.UpdateSquadRank();
self.SetLegend();
self.SetObjectives();
Network.SendMessageOthers("UpdateLegend");
}

# Map Functions
function FindMapObjects()
{
self._captureZones = Map.FindMapObjectsByName("CaptureZone1");
for (object in self._captureZones)
{
self._captureZoneComponenets.Add(object.GetComponent("CaptureZone"));
self._allZoneCount = self._captureZoneComponenets.Count;
}
self._wagons = Map.FindMapObjectsByName("Wagon2a");
self._gateList = Map.FindMapObjectsByName("GateList");
self._castleRuinsList = Map.FindMapObjectsByName("CastleRuins");
self._rightRiverList = Map.FindMapObjectsByName("River");
self._leftRiverList = Map.FindMapObjectsByName("LeftRiver");
self._undergroundList = Map.FindMapObjectsByName("Underground");
self._forestList = Map.FindMapObjectsByName("Forest");
for (object in Map.FindMapObjectsByComponent("TitanSpawnForward"))
{
spawnerComponent = object.GetComponent("TitanSpawnForward");
if (spawnerComponent != null) { self._spawnerComponentList.Add(spawnerComponent); }
}
self._repairableObjectList = Map.FindMapObjectsByComponent("Repairable");

# Rumbling
rumblingActivateIds = "9377 14039 14035 14040 14041 14042 14043 14044 14045 14046 14047 14048 14057 14058 14059";
for (id in String.Split(rumblingActivateIds, " "))
{
object = Map.FindMapObjectByID(Convert.ToInt(id));
if (object != null) { self._rumblingActivate.Add (object); }
}
for (object in Map.FindMapObjectsByName("colossaltitan2"))
{
self._rumblingActivate.Add(object);
}

rumblingDeactivateIds = "8401 8402 8403 9376 7944 8404 8367 14025 14027";
for (id in String.Split(rumblingDeactivateIds, " "))
{
object = Map.FindMapObjectByID(Convert.ToInt(id));
if (object != null) { self._rumblingDeactivate.Add (object); }
}

musicActivateIds = "8401 8402 8403 8404 9377 14025 14026 14027";
for (id in String.Split(musicActivateIds, " "))
{
object = Map.FindMapObjectByID(Convert.ToInt(id));
if (object != null) { self._musicObjectList.Add(object); }
}
}

function SetDifficulty()
{
for (spawnerComponent in self._spawnerComponentList)
{
spawnerComponent.SetDifficultyMultiplier(self.DifficultyMultiplier);
}
}

function SetWagonSupplies()
{
for (wagon in Map.FindMapObjectsByComponent("Wagon"))
{
wagonComp = wagon.GetComponent("Wagon");
wagonComp.SetSupplyCount(self.SuppliesPerWagon);
}
}

function SetCannonWagonAmmo()
{
for (wagon in Map.FindMapObjectsByComponent("CannonWagon"))
{
cannonWagonComp = wagon.GetComponent("CannonWagon");
cannonWagonComp.SetAmmoCount(self.AmmoPerWagon);
}
}

function StartRumbling()
{
for (object in self._rumblingActivate) { object.Active = true; }
for (object in self._rumblingDeactivate) { object.Active = false; }
}

function ProcessCaptureZones()
{
for (zoneComponent in self._captureZoneComponenets)
{
# Zone Capture Part
if (zoneComponent.GetCurrentOwner() != "Human")
{
enabled = false;
for (wagon in self._wagons)
{
if(!enabled && wagon.Active && Vector3.Distance(zoneComponent.MapObject.Position, wagon.Position) <= 200)
{
enabled = true;
}
}
zoneComponent.Enabled = enabled;
continue;
}

if(zoneComponent.GetCurrentOwner() == "Human" && !self._zonesActivated.Contains(zoneComponent.Order))
{
self._zonesActivated.Add(zoneComponent.Order);
# Action on certain zones getting captured
if(zoneComponent.Order == 1)
{
for(object in self._gateList)
{
object.Active = false;
}
}
elif(zoneComponent.Order == 2)
{
for(object in self._castleRuinsList)
{
object.Active = true;
}
}
elif(zoneComponent.Order == 4)
{
for(object in self._forestList)
{
object.Active = true;
}
}
elif(zoneComponent.Order == 6)
{
self._currentPhase = 2;
self.SetObjectives();
}
elif(zoneComponent.Order == 8)
{
self._currentPhase = 2;
self.SetObjectives();
}
elif(zoneComponent.Order == 10)
{
if (Network.IsMasterClient && self.RightReinforcementsEnabled)
{
for (player in Network.Players)
{
if (player.Character == null && player.GetCustomProperty(NamesEnum.Formation) == FormationsEnum.Right)
{
Game.SpawnPlayerAt(player, false, self._rightReinforcementsSpawn);
}
}
Game.PrintAll("Right Wing got reinforced..");
}

for(object in self._rightRiverList)   #This activates 3 cube colliders the destructible trigger,
{
object.Active = true;
}
}
elif(zoneComponent.Order == 11)
{
if (Network.IsMasterClient && self.LeftReinforcementsEnabled)
{
for (player in Network.Players)
{
if (player.Character == null && player.GetCustomProperty(NamesEnum.Formation) == FormationsEnum.Left)
{
Game.SpawnPlayerAt(player, false, self._leftReinforcementsSpawn);
}
}
Game.PrintAll("Left Wing got reinforced..");
}

for(object in self._leftRiverList) #this one activates the titan spawner and ActivateNameZone cube for left river point
{
object.Active = true;
}
}
elif(zoneComponent.Order == 19)
{
self._lastPointCaptured = true;
}
}
}

self._capturedZoneCount = 0;
for (zoneComponent in self._captureZoneComponenets)
{
if (zoneComponent.GetCurrentOwner() == "Human")
{
self._capturedZoneCount = self._capturedZoneCount + 1;
}
}

if (Network.IsMasterClient && !self.TrainingMode && self._lastPointCaptured && 
(self._capturedZoneCount == self._allZoneCount || (self._capturedZoneCount >= 10 && self.AllowOneWingWin))
&& (self.AllowAnnieSurviveWin || self._annie == null))
{
UI.SetLabelForTimeAll("MiddleCenter","Humanity Prevails!",120.00);
Game.End(120.00);
}
}

function ZoneTriggerMessage(message)
{
Game.Debug("Unhandled zone trigger: " + message);
}

# Utilities

function GetChatMode()
{
myPlayer = Network.MyPlayer;
if(self._chatModeIndex == 4 && self.EnableHumanAllChat) { return ChatTypeEnum.All; }
elif(myPlayer.Character == null) { return ChatTypeEnum.Dead; }
elif(self._chatModeIndex == 0) { return ChatTypeEnum.Proximity; }
elif(self._chatModeIndex == 1 && myPlayer.GetCustomProperty(NamesEnum.Squad) != NamesEnum.NA) { return ChatTypeEnum.Squad; }
elif(self._chatModeIndex == 2 && myPlayer.GetCustomProperty(NamesEnum.Formation) != NamesEnum.NA) { return ChatTypeEnum.Formation; }
elif(self._chatModeIndex == 3 && myPlayer.GetCustomProperty(NamesEnum.Rank) == RanksEnum.CommunicationOfficer) { return ChatTypeEnum.Officer; }
else { return ChatTypeEnum.Proximity; }
}

function GetColorWrapped(code)
{
return UI.WrapStyleTag(code, "color", self.GetColorHex(code));
}

function GetStringColorWrapped(string, code)
{
return UI.WrapStyleTag(string, "color", self.GetColorHex(code));
}

function GetColor(code)
{
return Color(self.GetColorHex(code));
}

function GetColorHex(code)
{
# Ranks
if (code == RanksEnum.Commander) { return "#D4FF00"; }
elif (code == RanksEnum.SectionCommander) { return "#9267C7"; }
elif (code == RanksEnum.CommunicationOfficer) { return "#009A00"; }
elif (code == RanksEnum.Eren) { return "#FF8614"; }
elif (code == RanksEnum.Medic) { return "#EC4042"; }
elif (code == RanksEnum.Engineer) { return "#90D5FF"; }
elif (code == RanksEnum.Private) { return "#54FF90"; }
elif (code == RanksEnum.Cadet) { return "#4A84E0"; }
# Squads
elif (code == SquadsEnum.Recon) { return "#40E3A4"; }
elif (code == SquadsEnum.SupplyGuard) { return "#D69347"; }
elif (code == SquadsEnum.RearGuard) { return "#D64763"; }
# Formations
elif (code == FormationsEnum.Left) { return "#2EB9DB"; }
elif (code == FormationsEnum.Right) { return "#D64291"; }
# Roles
elif (code == "Scout") { return "#2F7FF7"; }
# Chat
elif (code == ChatTypeEnum.Dead) { return "#808080"; }
elif (code == ChatTypeEnum.Proximity) { return "#6076D5"; }
elif (code == ChatTypeEnum.Squad) { return "#7FD560"; }
elif (code == ChatTypeEnum.Formation) { return "#FFA500"; } #TODO - set color for this :)
elif (code == ChatTypeEnum.Officer) { return "#009A00"; } #TODO - set color for this :)
elif (code == ChatTypeEnum.All) { return "#FFAD00"; } #TODO - set color for this :)
# Other
elif (code == "Zone") { return "#79d6ff"; }
elif (code == "Objectives") { return "orange"; }
# Fallback
elif (code == NamesEnum.NA) { return "#0000FF"; }
else
{
Game.Debug("Not good! Color hex not found: " + code);
return "#000000";
}
}

function GetProgressBar(current, max, barLength, color)
{
barLeft = Math.Round(Convert.ToFloat(current)/Convert.ToFloat(max)*barLength);

str = "<size=20><color=" + color + ">";
for(i in Range(0, barLeft, 1)){str = str + "▇";}
str = str + "</color><color=#505050>";
for(i in Range(barLeft, barLength, 1)){str = str + "▇";}
str = str +"</color></size>";
return str;
}

function FormatChatMessage(message, chatMode)
{
color = self.GetColorHex(chatMode);
chatMsg = "[" + Network.MyPlayer.ID + "] " + Network.MyPlayer.Name + " ";
chatMode = "<color=" + color + ">(" + chatMode + ")</color>";
chatMsg += chatMode + "<color=white>: " + message + "</color>";
return chatMsg;
}

function SpawnShifter(health, realShifter, type, size, damage, explotionRadius, position)
{
titan = null;
if (realShifter == false) { titan = Game.SpawnTitanAt(type, position); }
else { titan = Game.SpawnShifter(type); }

if (titan == null) { return; }
Game.SpawnEffect("ShifterThunder", titan.Position, Vector3.Zero, explotionRadius * 2.0);
titan.Size = size;
titan.MaxHealth = health;
titan.Health = health;
titan.CustomDamageEnabled = true;
titan.CustomDamage = damage;
titan.Reveal(5);

return titan;
}

function UpdateSquadRank()
{
myPlayer = Network.MyPlayer;
formationText = Convert.ToString(myPlayer.GetCustomProperty(NamesEnum.Formation));
squadText = Convert.ToString(myPlayer.GetCustomProperty(NamesEnum.Squad));
rankText = Convert.ToString(myPlayer.GetCustomProperty(NamesEnum.Rank));
myPlayer.SetCustomProperty("SquadRank", formationText + " | " + squadText + " | " + rankText);
}

function OutlineModeText()
{
if (self._outlineMode == 0) { return OutlinesEnum.None; }
elif (self._outlineMode == 1) { return OutlinesEnum.Squad; }
elif (self._outlineMode == 2) { return OutlinesEnum.Formation; }
elif (self._outlineMode == 3) { return OutlinesEnum.Scouts; }
}

# UI Functions

function PrepareUI()
{
# Formation popup
UI.CreatePopup("FormationPopup", "Choose your formation", 400, 400);
UI.AddPopupButton("FormationPopup", "ChooseLeft", "Join " + self.GetColorWrapped(FormationsEnum.Left));
UI.AddPopupButton("FormationPopup", "ChooseRight", "Join " + self.GetColorWrapped(FormationsEnum.Right));

# Squad popup
UI.CreatePopup("SquadPopup", "Choose your squad", 400, 700);
UI.AddPopupButton("SquadPopup", "JoinRecon", "Join " + self.GetColorWrapped(SquadsEnum.Recon));
UI.AddPopupButton("SquadPopup", "JoinSupply", "Join " + self.GetColorWrapped(SquadsEnum.SupplyGuard));
UI.AddPopupButton("SquadPopup", "JoinRear", "Join " + self.GetColorWrapped(SquadsEnum.RearGuard));

# Rank popup
UI.CreatePopup("RankPopup", "Choose your rank", 400, 700);
UI.AddPopupButton("RankPopup", "ChooseCommander", "Select " + self.GetColorWrapped(RanksEnum.Commander));
UI.AddPopupButton("RankPopup", "ChooseSectionCommander", "Select " + self.GetColorWrapped(RanksEnum.SectionCommander));
UI.AddPopupButton("RankPopup", "ChooseCommunicationOfficer", "Select " + self.GetColorWrapped(RanksEnum.CommunicationOfficer));
UI.AddPopupButton("RankPopup", "ChooseEren", "Select " + self.GetColorWrapped(RanksEnum.Eren));
UI.AddPopupButton("RankPopup", "ChooseMedic", "Select " + self.GetColorWrapped(RanksEnum.Medic));
UI.AddPopupButton("RankPopup", "ChooseEngineer", "Select " + self.GetColorWrapped(RanksEnum.Engineer));
UI.AddPopupButton("RankPopup", "ChoosePrivate", "Select " + self.GetColorWrapped(RanksEnum.Private));
UI.AddPopupButton("RankPopup", "ChooseCadet", "Select " + self.GetColorWrapped(RanksEnum.Cadet));

# Game Guide
UI.CreatePopup("GameGuide", "GAME GUIDE", 1000, 1000);
UI.AddPopupBottomButton("GameGuide", "Settings", "Settings");
UI.AddPopupBottomButton("GameGuide", "SquadButton", "Switch/Select Squad");
UI.AddPopupBottomButton("GameGuide", "FormationButton", "Formation");

# Settings
UI.CreatePopup("Settings", "Settings", 500, 500);
self.SetSettingsContent();

# Formation
UI.CreatePopup("Formation", "Formation", 1000, 1000);

self.SetGameGuideContent();

# Scoreboard setup
UI.SetScoreboardHeader("Formation | Squad | Rank");
UI.SetScoreboardProperty("SquadRank");

self.SetChatLabel();
self.SetLegend();
self.SetObjectives();
}

function SetFormationContent()
{
UI.ClearPopup("Formation");

leftComm = null;
rightComm = null;
leftCommOff = null;
rightCommOff = null;
eren = null;

leftCommOff = null;
rightCommOff = null;

leftReconComm = null;
rightReconComm = null;

leftSupplyComm = null;
rightSupplyComm = null;

leftRearComm = null;
rightRearComm = null;

leftWingCount = 0;
rightWingCount = 0;

leftMedicCount = 0;
rightMedicCount = 0;

leftEngineerCount = 0;
rightEngineerCount = 0;

cadetCount = 0;
privateCount = 0;

leftReconSquadCount = 0;
leftSupplySquadCount = 0;
leftRearSquadCount = 0;

rightReconSquadCount = 0;
rightSupplySquadCount = 0;
rightRearSquadCount = 0;

for (player in Network.Players)
{
rank = player.GetCustomProperty(NamesEnum.Rank);
squad = player.GetCustomProperty(NamesEnum.Squad);
formation = player.GetCustomProperty(NamesEnum.Formation);
if (formation == FormationsEnum.Left)
{
leftWingCount += 1;
if (squad == SquadsEnum.Recon) { 
leftReconSquadCount += 1; 
if (rank == RanksEnum.SectionCommander) {
leftReconComm = player; }
}
elif (squad == SquadsEnum.SupplyGuard) 
{ 
leftSupplySquadCount += 1;
if (rank == RanksEnum.SectionCommander) { leftSupplyComm = player; }
}
elif (squad == SquadsEnum.RearGuard) 
{ 
leftRearSquadCount += 1; 
if (rank == RanksEnum.SectionCommander) { leftRearComm = player; }
}

if (rank == RanksEnum.Medic) { leftMedicCount += 1; }
elif (rank == RanksEnum.Engineer) { leftEngineerCount += 1; }
elif (rank == RanksEnum.Cadet) { cadetCount += 1; }
elif (rank == RanksEnum.Private) { privateCount += 1; }
elif (rank == RanksEnum.Eren) { eren = player; }
elif (rank == RanksEnum.CommunicationOfficer) { leftCommOff = player; }
elif (rank == RanksEnum.Commander) { leftComm = player; }
}
elif (formation == FormationsEnum.Right)
{
rightWingCount += 1;
if (squad == SquadsEnum.Recon) { 
rightReconSquadCount += 1; 
if (rank == RanksEnum.SectionCommander) 
{ rightReconComm = player; }
}
elif (squad == SquadsEnum.SupplyGuard) 
{ 
rightSupplySquadCount += 1;
if (rank == RanksEnum.SectionCommander) { rightSupplyComm = player; }
}
elif (squad == SquadsEnum.RearGuard) 
{ 
rightRearSquadCount += 1; 
if (rank == RanksEnum.SectionCommander) { rightRearComm = player; }
}

if (rank == RanksEnum.Medic) { rightMedicCount += 1; }
elif (rank == RanksEnum.Engineer) { rightEngineerCount += 1; }
elif (rank == RanksEnum.Cadet) { cadetCount += 1; }
elif (rank == RanksEnum.Private) { privateCount += 1; }
elif (rank == RanksEnum.Eren) { eren = player; }
elif (rank == RanksEnum.CommunicationOfficer) { rightCommOff = player; }
elif (rank == RanksEnum.Commander) { rightComm = player; }
}
}

label = "";

# Eren
label += self.GetStringColorWrapped("Eren: ", RanksEnum.Eren);
if (eren != null) { label += eren.Name; }
label += String.Newline + String.Newline;

# Wing Commanders
label += self.GetStringColorWrapped("Left Comm.: ", RanksEnum.Commander);
if (leftComm != null) { label += leftComm.Name; }
label += "    ";
label += self.GetStringColorWrapped("Right Comm.: ", RanksEnum.Commander);
if (rightComm != null) { label += rightComm.Name; }
label += String.Newline + String.Newline;

# Wing Counts
label += self.GetStringColorWrapped("Left Wing: ", FormationsEnum.Left) + Convert.ToString(leftWingCount);
label += "    " + self.GetStringColorWrapped("Right Wing: ", FormationsEnum.Right) + Convert.ToString(rightWingCount);
label += String.Newline + String.Newline;

# Communication Officers
label += self.GetStringColorWrapped("Left Comm. Officer: ", RanksEnum.CommunicationOfficer);
if (leftCommOff != null) { label += leftCommOff.Name; }
label += "    ";
label += self.GetStringColorWrapped("Right Comm. Officer: ", RanksEnum.CommunicationOfficer);
if (rightCommOff != null) { label += rightCommOff.Name; }
label += String.Newline + String.Newline;

# Recon Squad Commanders
label += self.GetStringColorWrapped("Left Sect. Commander: ", SquadsEnum.Recon);
if (leftReconComm != null) { label += leftReconComm.Name; }
label += "    ";
label += self.GetStringColorWrapped("Right Sect. Commander: ", SquadsEnum.Recon);
if (rightReconComm != null) { label += rightReconComm.Name; }
label += String.Newline + String.Newline;

# Recon Squad
label += self.GetStringColorWrapped("Left Recon Squad Count: ", SquadsEnum.Recon);
label += Convert.ToString(leftReconSquadCount);
label += "    ";
label += self.GetStringColorWrapped("Right Recon Squad Count: ", SquadsEnum.Recon);
label += Convert.ToString(rightReconSquadCount);
label += String.Newline + String.Newline;

# Supply Guard Squad Commanders
label += self.GetStringColorWrapped("Left Sect. Commander: ", SquadsEnum.SupplyGuard);
if (leftSupplyComm != null) { label += leftSupplyComm.Name; }
label += "    ";
label += self.GetStringColorWrapped("Right Sect. Commander: ", SquadsEnum.SupplyGuard);
if (rightSupplyComm != null) { label += rightSupplyComm.Name; }
label += String.Newline + String.Newline;

# Supply Guard Squad
label += self.GetStringColorWrapped("Left Supply Guard Count: ", SquadsEnum.SupplyGuard);
label += Convert.ToString(leftSupplySquadCount);
label += "    ";
label += self.GetStringColorWrapped("Right Supply Guard Count: ", SquadsEnum.SupplyGuard);
label += Convert.ToString(rightSupplySquadCount);
label += String.Newline + String.Newline;

# Rear Guard Squad Commanders
label += self.GetStringColorWrapped("Left Sect. Commander: ", SquadsEnum.RearGuard);
if (leftRearComm != null) { label += leftRearComm.Name; }
label += "    ";
label += self.GetStringColorWrapped("Right Sect. Commander: ", SquadsEnum.RearGuard);
if (rightRearComm != null) { label += rightRearComm.Name; }
label += String.Newline + String.Newline;

# Rear Guard Squad
label += self.GetStringColorWrapped("Left Rear Guard Count: ", SquadsEnum.RearGuard);
label += Convert.ToString(leftRearSquadCount);
label += "    ";
label += self.GetStringColorWrapped("Right Rear Guard Count: ", SquadsEnum.RearGuard);
label += Convert.ToString(rightRearSquadCount);
label += String.Newline + String.Newline;

# Medic
label += self.GetStringColorWrapped("Left Medic Count: ", RanksEnum.Medic);
label += Convert.ToString(leftMedicCount);
label += "    ";
label += self.GetStringColorWrapped("Right Medic Count: ", RanksEnum.Medic);
label += Convert.ToString(rightMedicCount);
label += String.Newline + String.Newline;

# Engineer
label += self.GetStringColorWrapped("Left Engineer Count: ", RanksEnum.Engineer);
label += Convert.ToString(leftMedicCount);
label += "    ";
label += self.GetStringColorWrapped("Right Engineer Count: ", RanksEnum.Engineer);
label += Convert.ToString(rightMedicCount);
label += String.Newline + String.Newline;

# Cadets and Privates
label += self.GetStringColorWrapped("Privates: ", RanksEnum.Private) + Convert.ToString(privateCount);
label += "    " + self.GetStringColorWrapped("Cadets: ", RanksEnum.Cadet) +Convert.ToString(cadetCount);
label += String.Newline + String.Newline;

UI.AddPopupLabel("Formation", label);
}

function SetSettingsContent()
{
UI.ClearPopup("Settings");
UI.AddPopupButton("Settings", "FlareGuide", "Toggle Flare Guide " + self.GetToggleStateString(RoomData.GetProperty(PropertyEnum.FlareGuide, false)));
UI.AddPopupButton("Settings", "KeyGuide", "Toggle Key Guide " + self.GetToggleStateString(RoomData.GetProperty(PropertyEnum.KeyGuide, true)));
UI.AddPopupButton("Settings", "SelfOutline", "Toggle Self Outline " + self.GetToggleStateString(RoomData.GetProperty(PropertyEnum.SelfOutline, true)));
UI.AddPopupButton("Settings", "MusicToggle", "Toggle Music " + self.GetToggleStateString(RoomData.GetProperty(PropertyEnum.MusicToggle, true)));
}

function SetGameGuideContent()
{

headerText = UI.WrapStyleTag("WIN CONDITIONS:", "color", "orange");
text = headerText + String.Newline;
if (self.AllowOneWingWin) { text += self.GetStringColorWrapped("SCOUTS", "Scout") + ": Reach the Ocean!" + String.Newline; }
else { text += self.GetStringColorWrapped("SCOUTS", "Scout") + ": Capture all points and reach the Ocean!" + String.Newline; }
if (!self.AllowAnnieSurviveWin) { text += self.GetStringColorWrapped("SCOUTS", "Scout") + ": Defeat Annie!" + String.Newline; }
text += String.Newline;

headerText = UI.WrapStyleTag("CAPTURING POINTS:", "color", "orange");
text += headerText + String.Newline
+ "A wagon must be near the capture zone to start capturing it." + String.Newline
+ "Titans can capture points! Make sure you kill all of them" + String.Newline + String.Newline;

headerText = UI.WrapStyleTag("RANKS:", "color", "orange");
text += headerText + String.Newline
+ self.GetColorWrapped(RanksEnum.Cadet) + ": Good for nothing Titan Bait! (Bonus 100 HP)" + String.Newline
+ self.GetColorWrapped(RanksEnum.Private) + ": A battle hardened scout! (Gets Thunderspears)" + String.Newline
+ self.GetColorWrapped(RanksEnum.Engineer) + ": Scout who can repair wagons and build fortifications! (Bonus 100 HP and Thunderspears) [" 
+  Convert.ToString(self.EngineerLimit)+ " total]" + String.Newline
+ self.GetColorWrapped(RanksEnum.Medic) + ": Scout who gets " + self.MedicBandages + " bandages to heal others for 100hp (10s cooldown). [" 
+  Convert.ToString(self.MedicLimit)+ " total]" + String.Newline
+ self.GetStringColorWrapped("Comm. Officer" ,RanksEnum.CommunicationOfficer) + ": Scout that can comunicate with other Wing. (Bonus 100 HP) [Unique per Wing]" + String.Newline
+ self.GetColorWrapped(RanksEnum.SectionCommander) + ": Scout in command of their Squad. (Bonus 100 HP and Thunderspears) [Unique per Squad]" + String.Newline
+ self.GetColorWrapped(RanksEnum.Commander) + ": Scout in command of their Wing. (Bonus 200 HP) [Unique]" + String.Newline
+ self.GetColorWrapped(RanksEnum.Eren) + ": Humanity's last hope [Unique]" + String.Newline + String.Newline;

headerText = UI.WrapStyleTag("CHAT TYPES:", "color", "orange");
text += headerText + String.Newline
+ self.GetStringColorWrapped("Formation Chat", ChatTypeEnum.Formation) + ": Only your Formation can use and see your messages." + String.Newline
+ self.GetStringColorWrapped("Squad Chat:", ChatTypeEnum.Squad) + ": Only your Squad can use and see these messages." + String.Newline
+ self.GetStringColorWrapped("Proximity Chat", ChatTypeEnum.Proximity) + ": Only nearby players can see your messages!" + String.Newline
+ self.GetStringColorWrapped("Officer Chat", ChatTypeEnum.Officer) + ": Only Communication Offiers can use and see these messages." + String.Newline
+ self.GetStringColorWrapped("All Chat", ChatTypeEnum.All) + ": Everyone can see message." + String.Newline
+ self.GetStringColorWrapped("Dead Chat", ChatTypeEnum.Dead) + ": Only dead players can see your messages!" + String.Newline + String.Newline;

headerText = UI.WrapStyleTag("RESPAWNS:", "color", "orange");
text += headerText + String.Newline;
if (self.LeftReinforcementsEnabled && self.RightReinforcementsEnabled) { text += "Both Wings are reinforced on river point!"; }
elif (self.LeftReinforcementsEnabled) { text += "Left Wing is reinforced on river point!"; }
elif (self.RightReinforcementsEnabled) { text += "Right Wing is reinforced on river point!"; }
else { text += "We have no reinforcements!"; }
text += String.Newline + String.Newline;

headerText = UI.WrapStyleTag("TIPS:", "color", "orange");
text += headerText + String.Newline
+ "1. Stick with your squad and/or a partner to increase survivability!" + String.Newline
+ "2. Shifter transformation can kill you. Stay clear!" + String.Newline
+ "3. Be smart with gas and weapons! Supplies are limited!." + String.Newline
+ "4. Protect wagons, they are destroyable (25 refills per wagon and 100 ammo per cannon wagon)!" + String.Newline
+ "5. Protect your horses, they do not follow you and are destroyable!" + String.Newline
+ "6. Gas cylinders are scattered around and offer supplies (1 per cylinder)!" + String.Newline
+ "7. Titans can capture points! Make sure you kill all of them!!" + String.Newline
+ "8. Use any means necessary to stay alive!!!" + String.Newline
+ "9. Stay on high alert when engaging! the Titans have been acting strangely as of late..." + String.Newline
+ "10. You can strip soldier under ur command using /dismiss [id] command" + String.Newline + String.Newline;
UI.AddPopupLabel("GameGuide", text);
}

function SetChatLabel()
{
chatType = self.GetChatMode();
text = UI.WrapStyleTag("                                                                       [7]: <<", "color", "orange") + self.OutlineModeText() + UI.WrapStyleTag(">>", "color", "orange");
text += String.Newline;
text += UI.WrapStyleTag("                                                                       [F4]: <<", "color", "orange") +  chatType + UI.WrapStyleTag(">>", "color", "orange");
UI.SetLabel("BottomLeft", text);
}

function SetLegend()
{
myCharacter = Network.MyPlayer.Character;
myPlayer = Network.MyPlayer;
rank = myPlayer.GetCustomProperty(NamesEnum.Rank);
squad = myPlayer.GetCustomProperty(NamesEnum.Squad);
formation = myPlayer.GetCustomProperty(NamesEnum.Formation);

legend = "";

if(self._hideHUD == true)
{
UI.SetLabel("TopLeft", legend);
return;
}

if(RoomData.GetProperty(PropertyEnum.FlareGuide, false))
{
legend += UI.WrapStyleTag("Flare Guide:", "color", "orange") + String.Newline
+ UI.WrapStyleTag("Green- ", "color", "lime")  + "All clear!/Go that way!" + String.Newline
+ UI.WrapStyleTag("Red- ", "color", "red") + "Titan spotted!" + String.Newline
+ UI.WrapStyleTag("Black- ", "color", "black") + "Thrower/Crawler/₣____ spotted!" + String.Newline
+ UI.WrapStyleTag("Purple- ", "color", "purple") + "Need Medic/Assistance!" + String.Newline
+ UI.WrapStyleTag("Blue- ", "color", "blue") + "Retreat/Halt" + String.Newline
+ UI.WrapStyleTag("Yellow- ", "color", "yellow") + "Regroup!/Wagon Leaving!" + String.Newline;
}

if(RoomData.GetProperty(PropertyEnum.KeyGuide, true))
{
legend += UI.WrapStyleTag("FUNCTION KEYS:", "color", "orange") + String.Newline
+ "[F1]" + UI.WrapStyleTag("- to Switch Weapon", "color", "#fffe32") + String.Newline
+ "[F2]" + UI.WrapStyleTag("- to Use Role Special (if applicable)", "color", "#d3ff37") + String.Newline
+ "[F3]" + UI.WrapStyleTag("- to Hide Hud", "color", "#fffe32") + String.Newline
+ "[F4]" + UI.WrapStyleTag("- to Switch Chat", "color", "#d3ff37") + String.Newline
+ "[H]" + UI.WrapStyleTag("- to Share Gas", "color", "#fffe32") + String.Newline
+ "[J]" + UI.WrapStyleTag("- to Push People", "color", "#d3ff37") + String.Newline
+ "[7]" + UI.WrapStyleTag("- to Toggle Outline Mode", "color", "#fffe32") + String.Newline
+ "[8]" + UI.WrapStyleTag("- to Open Game Guide and Settings", "color", "#d3ff37") + String.Newline;
}

commanderName = "";
sectionCommanderName = "";

if (formation != NamesEnum.NA){
for (p in Network.Players)
{
if (p.GetCustomProperty(NamesEnum.Formation) == formation && p.GetCustomProperty(NamesEnum.Rank) == RanksEnum.Commander)
{
commanderName = p.Name;
break;
}
}
for (p in Network.Players)
{
if (p.GetCustomProperty(NamesEnum.Formation) == formation && p.GetCustomProperty(NamesEnum.Squad) == squad && p.GetCustomProperty(NamesEnum.Rank) == RanksEnum.SectionCommander)
{
sectionCommanderName = p.Name;
break;
}
}

legend += UI.WrapStyleTag("Squad Info:", "color", "orange");
if (commanderName != ""){ legend += String.Newline + "Commander " + "[" + commanderName + "]"; }
if (sectionCommanderName != ""){ legend += String.Newline + "Sect.Commander "  + "[" + sectionCommanderName + "]";}
if (formation != NamesEnum.NA){ legend += String.Newline + "Formation- " + self.GetColorWrapped(Convert.ToString(formation));}
if (squad != NamesEnum.NA){ legend += String.Newline + "Squad- " + self.GetColorWrapped(Convert.ToString(squad));}
if (rank != NamesEnum.NA){ legend += String.Newline + "Rank- " + self.GetColorWrapped(Convert.ToString(rank)); }
if(rank == RanksEnum.Medic) 
{ 
legend += String.Newline + "Bandages: " + (self.MedicBandages - self._bandagesUsedCounter); 
if (self._healCooldown > 0) { legend += String.Newline + "Cooldown: " + String.FormatFloat(self._healCooldown, 0); }
elif (self._closestHuman == null) { legend += String.Newline + UI.WrapStyleTag("[F2]", "color", "orange") + ": No target"; }
else { legend += String.Newline + UI.WrapStyleTag("[F2]", "color", "orange") + ": Heal " + self._closestHuman.Name; }
}
elif (rank == RanksEnum.Engineer) 
{ 
legend += String.Newline + "Resources: " + (self.EngineerResources - self._resourcesUsed);
if (self._fixCooldown > 0) { legend += String.Newline + "Cooldown: " + String.FormatFloat(self._fixCooldown, 0); }
elif (self._closestRepairable == null) { legend += String.Newline + UI.WrapStyleTag("[F2]", "color", "orange") + ": No target"; }
elif (myCharacter != null && self._closestRepairable != null) 
{ 
healthComponent = self._closestRepairable.GetComponent("DestroyableObject");
repairableComponent = self._closestRepairable.GetComponent("Repairable");
legend += String.Newline + UI.WrapStyleTag("[F2]", "color", "orange") + ": Target: "; 
legend += " (" + Convert.ToInt(healthComponent.GetHealth()) + "/" + Convert.ToInt(healthComponent.GetMaxHealth()) + ")";
legend += String.Newline + "Cost: " + Convert.ToString(repairableComponent.GetCost()) + " (" + Convert.ToString(repairableComponent.GetHealthRestored() + "HP)"); 
}
}
elif (rank == RanksEnum.Eren) 
{ 
legend += String.Newline + "Transformations: " + (self.ErenTransformations - self._erenTransformationCounter); 
if (myCharacter != null && myCharacter.Type == "Shifter") { legend += String.Newline + UI.WrapStyleTag("[F2]", "color", "orange") + ": Unshift "; }
elif (self._erenCooldown > 0) { legend += String.Newline + "Cooldown: " + String.FormatFloat(self._erenCooldown, 0); }
else { legend += String.Newline + UI.WrapStyleTag("[F2]", "color", "orange") + ": Transform "; }
}
}

UI.SetLabel("TopLeft", legend);
}

function SetObjectives()
{
rank = Network.MyPlayer.GetCustomProperty(NamesEnum.Rank);
squad = Network.MyPlayer.GetCustomProperty(NamesEnum.Squad);
formation = Network.MyPlayer.GetCustomProperty(NamesEnum.Formation);

annie = null;
if (Game.AIShifters.Count > 0) { annie = Game.AIShifters.Get(0); }

objective = "";

if (self._hideHUD == true){
UI.SetLabel("TopRight", objective);
return;
}

objective += "<" + self.GetStringColorWrapped("OBJECTIVES", "Objectives") + ">";
objective += String.Newline;

if (formation == NamesEnum.NA || squad == NamesEnum.NA){ objective += "Join a Squad!" + String.Newline; }
elif (self._currentPhase == 0) { objective += "Secure the Front Gate!" + String.Newline; }
else { objective += "Explore what lies beyond the walls!" + String.Newline; }

if (annie != null) { objective += "Hunt down Annie! [" + UI.WrapStyleTag(Convert.ToString(annie.Health) + " HP", "color", "red") + "]" + String.Newline; }

if (squad == SquadsEnum.Recon) { objective += "[" + self.GetColorWrapped(SquadsEnum.Recon) + "] Go ahead of the Formation and scout the area!" + String.Newline; }
elif (squad == SquadsEnum.SupplyGuard) { objective += "[" + self.GetColorWrapped(SquadsEnum.SupplyGuard) + "] Stick with the Supply Wagon's and protect them from Titans!" + String.Newline; }
elif (squad == SquadsEnum.RearGuard) { objective += "[" + self.GetColorWrapped(SquadsEnum.RearGuard) + "] Stick with the Cannon Wagon's and protect them from Titans!" + String.Newline; }

if (rank == RanksEnum.Commander) { objective += "[" + self.GetColorWrapped(RanksEnum.Commander) + "] Lead your " + self.GetColorWrapped(NamesEnum.Formation) + "!"; }
elif (rank == RanksEnum.SectionCommander) { objective += "[" + self.GetColorWrapped(RanksEnum.Commander) + "] Lead your " + self.GetColorWrapped(NamesEnum.Squad) + "!"; }
elif (rank == RanksEnum.CommunicationOfficer) { objective += "[" + self.GetColorWrapped(RanksEnum.Commander) + "] Asist your "  + self.GetColorWrapped(RanksEnum.Commander) + "!"; }
elif (rank == RanksEnum.Eren) { objective += "[" + self.GetColorWrapped(RanksEnum.Eren) + "] Help expedition get to ocean!"; }
elif (rank == RanksEnum.Engineer) { objective += "[" + self.GetColorWrapped(RanksEnum.Engineer) + "] Fix and fortify!"; }
elif (rank == RanksEnum.Medic) { objective += "[" + self.GetColorWrapped(RanksEnum.Medic) + "] Help hurt soldiers!"; }
elif (rank == RanksEnum.Private) { objective += "[" + self.GetColorWrapped(RanksEnum.Private) + "] Fight and survive!"; }
elif (rank == RanksEnum.Cadet) { objective += "[" + self.GetColorWrapped(RanksEnum.Cadet) + "] Survive!"; }

UI.SetLabel("TopRight", objective);
}

function PrintStartMessages()
{
Game.Print("---" + String.Newline + "Welcome to Xtreme Expedition - Used Cheese Bandit's Road to the Ocean Map as a base.");

text = "Press [8] to view Game Guide!" + String.Newline
+ "Press [J] to Select your Squads!";
Game.Print(text);

label = "Welcome to Xtreme Expedition!" + String.Newline
+ "F3 to toggle HUD and [8] to view the Game Guide!";
label = UI.WrapStyleTag(label, "size", "30");
UI.SetLabelForTime("MiddleCenter", label, 20.0);
}

# Other Functions
function GetToggleStateString(state)
{
if (state) { return UI.WrapStyleTag("[ON]", "color", "green"); }
else { return UI.WrapStyleTag("[OFF]", "color", "red"); }
}

function SetRankWeapon(character)
{
if (character == null || character.Type != "Human") { return; }
rank = character.Player.GetCustomProperty(NamesEnum.Rank);
if (rank == null || (rank != RanksEnum.Private && rank != RanksEnum.Engineer && rank != RanksEnum.SectionCommander)) { character.SetWeapon("Blade"); }
}

function SetRankHealth(character)
{
if (character == null || character.Type != "Human") { return; }
rank = character.Player.GetCustomProperty(NamesEnum.Rank);
health = 300;
if (rank == RanksEnum.Commander) { health += 200; }
elif (rank == RanksEnum.SectionCommander || rank == RanksEnum.CommunicationOfficer || rank == RanksEnum.Cadet || rank == RanksEnum.Engineer) { health += 100; }
character.MaxHealth = health;
character.Health = health;
}

function OutlineHumans()
{
myFormation = Network.MyPlayer.GetCustomProperty(NamesEnum.Formation);
mySquad = Network.MyPlayer.GetCustomProperty(NamesEnum.Squad);
myCharacter = Network.MyPlayer.Character;
myPlayer = Network.MyPlayer;
for(human in Game.Humans)
{
if(human == myCharacter)
{
if(RoomData.GetProperty(PropertyEnum.SelfOutline, true) && self._outlineMode != 0) { human.AddOutline(self.GetColor(human.Player.GetCustomProperty(NamesEnum.Rank)), "OutlineVisible"); }
else { human.RemoveOutline(); }
}
else
{
formation = human.Player.GetCustomProperty(NamesEnum.Formation);
squad = human.Player.GetCustomProperty(NamesEnum.Squad);
if (myCharacter == null || Vector3.Distance(myCharacter.Position, human.Position) <= self.OutlineRange)
{
if(self._outlineMode == 3 || (myFormation == formation && myFormation != null))
{
if(self._outlineMode == 3 || self._outlineMode == 2 || (self._outlineMode == 1 && mySquad == squad && squad != null))
{
human.AddOutline(self.GetColor(human.Player.GetCustomProperty(NamesEnum.Rank)), "OutlineVisible");
continue;
}
}
}
human.RemoveOutline();
}
}
}

function FindClosestHuman()
{
self._closestHuman = null;
self._closestHumanDistance = null;
myCharacter = Network.MyPlayer.Character;
if (myCharacter == null) { return; }

for(human in Game.PlayerHumans)
{
if (human == myCharacter) { continue; }

humanDistance = Vector3.Distance(myCharacter.Position, human.Position);
if(humanDistance < self.HumanInteractionDistance && (self._closestHuman == null || humanDistance < self._closestHumanDistance))
{
self._closestHuman = human;
self._closestHumanDistance = humanDistance;
}
}

if (self._closestHuman != null) { Network.SendMessage(self._closestHuman.Player, "StatsRequest"); }
}

function FindClosestRepairable()
{
self._closestRepairable = null;
self._closestRepairableDistance = null;
myCharacter = Network.MyPlayer.Character;
if (myCharacter == null) { return; }

for(object in self._repairableObjectList)
{
if (!object.Active) { continue; }

objectDistance = Vector3.Distance(myCharacter.Position, object.Position);
if(objectDistance < self.EngineerFixRange && (self._closestRepairable == null || objectDistance < self._closestRepairableDistance))
{
self._closestRepairable = object;
self._closestRepairableDistance = objectDistance;
}
}
}

function SetBottomLabel()
{
myCharacter = Network.MyPlayer.Character; 
label = "";
if (myCharacter == null) 
{
UI.SetLabelForTime("BottomCenter", label, 1.1);
return;
}

if(self._closestHuman != null && self._closestHumanStats != null)
{
label += UI.WrapStyleTag("[Target] ", "color", "orange");
name = self._closestHuman.Name;
while (String.Length(name) < 16) { name += " "; }
label += name;

label += "  " + UI.WrapStyleTag("[Gas] ", "color", "orange");
label += String.FormatFloat(self._closestHumanStats.CurrentGas, 0) + "/" + String.FormatFloat(self._closestHumanStats.MaxGas, 0);

label += "  " + UI.WrapStyleTag("[Health] ", "color", "orange");
label += self._closestHuman.Health + "/" + self._closestHuman.MaxHealth; 

label += String.Newline;
}

if(myCharacter != null && myCharacter.MaxHealth > 1 && Game.GetMiscSetting("RealismMode"))
{
label += self.GetProgressBar(myCharacter.Health, myCharacter.MaxHealth, 25, "#00FF00") + " <size=15>(" + myCharacter.Health + "/" + myCharacter.MaxHealth + ")</size>";
}
else { label += String.Newline; }
label += String.Newline + String.Newline + String.Newline;
UI.SetLabelForTime("BottomCenter", label, 1.1);
}

function SetInitialSettings()
{
myPlayer = Network.MyPlayer;

if (myPlayer.GetCustomProperty(NamesEnum.Formation) == null) { myPlayer.SetCustomProperty(NamesEnum.Formation, NamesEnum.NA); }
if (myPlayer.GetCustomProperty(NamesEnum.Squad) == null) { myPlayer.SetCustomProperty(NamesEnum.Squad, NamesEnum.NA); }
if (myPlayer.GetCustomProperty(NamesEnum.Rank) == null) { myPlayer.SetCustomProperty(NamesEnum.Rank, NamesEnum.NA); }

self.UpdateSquadRank();
}

function TitanChangeTime()
{
for(titan in Game.AITitans)
{
self.ApplyTitanSettings(titan);
}
}

function ApplyTitanDamage(titan)
{
titan.CustomDamageEnabled = true;
titanSizeDiff = titan.Size - self._titanSizeAverage;
dmg = self.TitanBaseDamage + (titanSizeDiff / self._titanSizeDifference) * self.TitanDamageChange;
dmg = Math.Round(dmg);
titan.CustomDamage = dmg;
}

function ApplyTitanSettings(titan)
{
if (titan == null) { return; }
if (titan.Size > 4.2) { return; } # Colossal
if (self._timeOfDay == DayTimeEnum.Day)
{
titan.DetectRange = self._DayTitanDetectRange;
titan.FocusRange = self._DayTitanFocusRange;
titan.FocusTime = self._DayTitanFocusTime;
titan.RunSpeedBase = self._DayTitanRunSpeedBase;
titan.WalkSpeedBase = self._DayTitanWalkSpeedBase;
titan.RunSpeedPerLevel = self._DayTitanRunSpeedPerLevel;
titan.WalkSpeedPerLevel = self._DayTitanWalkSpeedPerLevel;
titan.TurnSpeed = self._DayTitanTurnSpeed;
titan.RotateSpeed = self._DayTitanRotateSpeed;
titan.JumpForce = self._DayTitanJumpForce;
titan.AttackSpeedMultiplier = self._DayTitanAttackSpeed;
titan.AttackWait = self._DayTitanAttackWait;
titan.AttackPause = self._DayTitanAttackPause;
titan.TurnPause = self._DayTitanTurnPause;
titan.Emote("Roar");
}
elif (self._timeOfDay == DayTimeEnum.Night)
{
titan.DetectRange = self._NightTitanDetectRange;
titan.FocusRange = self._NightTitanFocusRange;
titan.FocusTime = self._NightTitanFocusTime;
titan.RunSpeedBase = self._NightTitanRunSpeedBase;
titan.WalkSpeedBase = self._NightTitanWalkSpeedBase;
titan.RunSpeedPerLevel = self._NightTitanRunSpeedPerLevel;
titan.WalkSpeedPerLevel = self._NightTitanWalkSpeedPerLevel;
titan.TurnSpeed = self._NightTitanTurnSpeed;
titan.RotateSpeed = self._NightTitanRotateSpeed;
titan.JumpForce = self._NightTitanJumpForce;
titan.AttackSpeedMultiplier = self._NightTitanAttackSpeed;
titan.AttackWait = self._NightTitanAttackWait;
titan.AttackPause = self._NightTitanAttackPause;
titan.TurnPause = self._NightTitanTurnPause;
titan.PlaySound("Grunt7");
}
}

function CheckInputs()
{
myPlayer = Network.MyPlayer;
myCharacter = Network.MyPlayer.Character;
myRank = myPlayer.GetCustomProperty(NamesEnum.Rank);

if(Input.GetKeyDown("Interaction/Function1") && myCharacter != null
&& myRank != null && (myRank == RanksEnum.Private || myRank == RanksEnum.Engineer || myRank == RanksEnum.SectionCommander))
{
if (myCharacter.Weapon == "Blade"){
self._bladeDurability = myCharacter.CurrentBladeDurability;
self._bladesLeft = myCharacter.CurrentBlade;
self._gasLeft = myCharacter.CurrentGas;
self._currentSpecial = myCharacter.CurrentSpecial;

myCharacter.SetWeapon("Thunderspears");
myCharacter.CurrentGas = self._gasLeft;
myCharacter.SetSpecial(self._currentSpecial);
}
else
{
self._roundsLeft = myCharacter.CurrentAmmoRound;
self._spearsLeft = myCharacter.CurrentAmmoLeft;
self._gasLeft = myCharacter.CurrentGas;
self._currentSpecial = myCharacter.CurrentSpecial;

myCharacter.SetWeapon("Blades");
myCharacter.CurrentGas = self._gasLeft;
myCharacter.SetSpecial(self._currentSpecial);
}
}

if(Input.GetKeyDown("Interaction/Function2") && myCharacter != null)
{
if(myRank == RanksEnum.Medic) # Medic OnFrame
{
if (self._closestHuman == null) { return; }
elif (self._bandagesUsedCounter >= self.MedicBandages) { UI.SetLabelForTime("MiddleCenter", "Out of bandages.", 1.0); }
elif (self._healCooldown > 0) { UI.SetLabelForTime("MiddleCenter", "Skill on cooldown.", 1.0); }
elif (self._closestHuman.Health == self._closestHuman.MaxHealth ) { UI.SetLabelForTime("MiddleCenter", "Target is healthy.", 1.0); }
elif (self._closestHuman.MaxHealth < self.MedicHealAmount) { UI.SetLabelForTime("MiddleCenter", "Target not capable of healing.", 1.0); }
else
{
Network.SendMessage(self._closestHuman.Player, "HealRequest");
self._healCooldown = self.MedicHealCooldown;
}
}
if(myRank == RanksEnum.Engineer) # Medic OnFrame
{
if (self._closestRepairable == null) { return; }
repairableComponent = self._closestRepairable.GetComponent("Repairable");

if (self._resourcesUsed >= self.EngineerResources) { UI.SetLabelForTime("MiddleCenter", "Out of resources.", 1.0); }
if (repairableComponent.GetCost() > (self.EngineerResources - self._resourcesUsed)) { UI.SetLabelForTime("MiddleCenter", "Not enough resources.", 1.0); }
elif (self._fixCooldown > 0) { UI.SetLabelForTime("MiddleCenter", "Skill on cooldown.", 1.0); }
elif (!repairableComponent.CanRepair()) { UI.SetLabelForTime("MiddleCenter", "Target can't be fixed.", 1.0); }
elif (repairableComponent.Fix())
{
self._resourcesUsed += repairableComponent.GetCost();
self._fixCooldown = self.EngineerFixCooldown;
self._closestRepairable = null;
self._closestRepairableDistance = null;
self.SetLegend();
}
}
elif (myRank == RanksEnum.Eren)
{
if (myCharacter.Type == "Shifter")
{
Network.SendMessage(Network.MasterClient, "ErenUnshift");
}
elif (myCharacter.Type == "Human" && !myCharacter.IsMounted && self._erenCooldown <= 0 && self._erenTransformationCounter < self.ErenTransformations)
{
myCharacter.SetSpecial("Eren"); 
myCharacter.SpecialCooldown = 0;
myCharacter.ShifterLiveTime = self.ErenTransformationLength;
myCharacter.ActivateSpecial();
}
}
}

if(Input.GetKeyDown("Interaction/Function3"))
{
if(self._hideHUD)
{
self._hideHUD = false;
self.SetLegend();
self.SetObjectives();
}
else
{
self._hideHUD = true;
UI.SetLabel("TopRight", "");
UI.SetLabel("TopLeft", "");
UI.SetLabel("MiddleRight", "");
UI.SetLabel("BottomCenter", "");
}
}

if(Input.GetKeyDown("Interaction/Function4"))
{
if(myCharacter == null && self.EnableHumanAllChat) # All chat for dead 
{
if (self._chatModeIndex == self._chatModeList.Count - 1) { self._chatModeIndex = 0; }
else { self._chatModeIndex = self._chatModeList.Count - 1; }
}
else
{
self._chatModeIndex += 1;
}

if (Network.MyPlayer.GetCustomProperty(NamesEnum.Rank) != RanksEnum.CommunicationOfficer 
&& self._chatModeIndex == 3)
{
self._chatModeIndex += 1; 
}

self._chatModeIndex = Math.Mod(self._chatModeIndex, self._chatModeList.Count); 

self.SetChatLabel();  
}

if(Input.GetKeyDown("Interaction/Interact2") && myCharacter != null)
{
if(self._closestHuman == null || self._closestHumanStats == null) { return; }
elif(myCharacter.CurrentGas <= 9) { UI.SetLabelForTime("MiddleCenter", "Not enough gas", 1.0); }
elif(self._closestHumanStats.MaxGas - self._closestHumanStats.CurrentGas <= 9) { UI.SetLabelForTime("MiddleCenter", "Target does not need gas", 1.0); }
else
{
Network.SendMessage(self._closestHuman.Player, "ShareGas");
self._closestHumanStats = null;
}
}

if(Input.GetKeyDown("Interaction/Interact3") && myCharacter != null && myCharacter.Type == "Human" && self._pushCooldown <= 0)
{
if(self._closestHuman != null) 
{ 
Network.SendMessage(self._closestHuman.Player, "AddForce"); 
self._pushCooldown = 3;
}
}

if(Input.GetKeyDown("Interaction/QuickSelect7"))
{
self._outlineMode += 1;
self._outlineMode = Math.Mod(self._outlineMode, 4);
self.SetChatLabel();
Network.MyPlayer.Character.Unmount();
}

if(Input.GetKeyDown("Interaction/QuickSelect8"))
{
UI.ShowPopup("GameGuide");
}
}

function TimersOnTick()
{
if (self._healCooldown > 0) { self._healCooldown -= Time.TickTime; }
if (self._fixCooldown > 0) { self._fixCooldown -= Time.TickTime; }
if (self._pushCooldown > 0) { self._pushCooldown -= Time.TickTime; }
if (self._erenCooldown > 0 && Network.MyPlayer.Character != null && Network.MyPlayer.Character.Type == "Human") 
{ self._erenCooldown -= Time.TickTime; }

if (!RoomData.GetProperty(PropertyEnum.MusicToggle, true))
{
for (object in self._musicObjectList) 
{ 
object.Active = false; 
}
}

if(!Network.IsMasterClient) { return; }

if (self._timeCounter > 0) { self._timeCounter -= Time.TickTime; }

if(self._timeCounter <= 0)
{
if(self._timeOfDay == DayTimeEnum.Day)
{
self._timeOfDay = DayTimeEnum.Night;
self._timeCounter = self.NightDuration;
self.TitanChangeTime();
}
elif(self._timeOfDay == DayTimeEnum.Night)
{
self._timeOfDay = DayTimeEnum.Day;
self._timeCounter = self.DayDuration;
self.TitanChangeTime();
}
}
}

function CheckSkillBan()
{
myCharacter = Network.MyPlayer.Character;
rank = Network.MyPlayer.GetCustomProperty(NamesEnum.Rank);

if(self.SkillBan && myCharacter != null && myCharacter.Type == "Human" && myCharacter.IsMainCharacter){
if(myCharacter.CurrentSpecial == "Dance" || myCharacter.CurrentSpecial == "Distract" || myCharacter.CurrentSpecial == "DownStrike"
|| myCharacter.CurrentSpecial == "Supply" || myCharacter.CurrentSpecial == "Annie" || (myCharacter.CurrentSpecial == "Eren" && rank != RanksEnum.Eren))
{
myCharacter.SetSpecial("Escape");
}
}
}

function AddForce(human)
{
myCharacter = Network.MyPlayer.Character;

if (myCharacter != null && human != null)
{
direction = myCharacter.Position - human.Position;
direction.Y = 0;
myCharacter.AddForce(direction.Normalized * self.PushForce + Vector3.Up * 0.5 * self.PushForce, "Impulse");
}
}
}

class PlayerStats
{
Player = null;
CurrentGas = null;
MaxGas = null;

function Init(player, currentGas, maxGas) {
self.Player = player;
self.CurrentGas = currentGas;
self.MaxGas = maxGas;
}
}

# Enums

extension RanksEnum
{
Commander = "Commander";
SectionCommander = "Section Commander";
CommunicationOfficer = "Communication Officer";
Medic = "Medic";
Engineer = "Engineer";
Private = "Private";
Cadet = "Cadet";
Eren = "Eren";
}

extension SquadsEnum
{
Recon = "Recon Squad";
SupplyGuard = "Supply Guard Squad";
RearGuard = "Rear Guard Squad";
}

extension FormationsEnum
{
Left = "Left Wing";
Right = "Right Wing";
}

extension NamesEnum
{
Formation = "Formation";
Squad = "Squad";
Rank = "Rank";
NA = "N/A";
}

extension DayTimeEnum
{
Day = "Day";
Night = "Night";
}

extension ChatTypeEnum
{
Dead = "Dead";
Proximity = "Proximity";
Squad = "Squad";
Formation = "Formation";
Officer = "Officer";
All = "All";
}

extension OutlinesEnum
{
None = "None";
Squad = "Squad";
Formation = "Formation";
Scouts = "Scouts";
}

extension PropertyEnum
{
SelfOutline = "SelfOutline";
KeyGuide = "KeyGuide";
FlareGuide = "FlareGuide";
MusicToggle = "MusicToggle";
}

extension SettingNames
{
TitanSizeEnabled = "TitanSizeEnabled";
TitanSizeMin = "TitanSizeMin";
TitanSizeMax = "TitanSizeMax";
}