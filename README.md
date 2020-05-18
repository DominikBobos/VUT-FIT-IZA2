link na GitHub repozitár: https://github.com/DominikBobos/VUT-FIT-IZA2

# Dokumentácia aplikácie MedPlanner k projektu do predmetu IZA

## Autor: Boboš Dominik (xbobos00)

#### 1. Popis aplikácie
Aplikácia **MedPlanner** slúži pacientom, ktorí potrebujú pravidelne užívať lieky. Slúži k organizácií a pripomienkam, aby danú liečbu užili v správnom čase. 
Poskytuje vkladať lieky, kde je možné napísať ich _názov_, zaznamenať _dátum počiatku_ liečby a taktiež aj _dátum plánovaného ukončenia_ liečby, taktež aj _čas_, kedy počas dňa je potrebné liek užiť. Užívateľ nemusí zadať všetky informácie. Pri zapnutí notifikácií v nastaveniach, aplikácia pripomenie čas užitia lieku na základe zadaného času užitia, v prípade, že je tento parameter vynechaný, nebude pre konkrétny liek ani zobrazovať oznámenia. Zoznam liekov je možné _editovať_, _meniť_ hodnoty, _pridať_ nový liek, _vymazanie_ lieku, či _presun_ položiek. Na obrazovke **"Now"** je možné sledovať aktuálny stav. To znamená, že v zozname **"Need to be taken"** zobrazuje také lieky s jednotlivými časmi, ktoré počas dňa ešte bude potrebné užiť a v zozname **"Should have been taken"** zobrazuje také, ktoré už mali byť užité. Samozrejme sa tu nezobrazujú také, ktorých interval dátumu liečby je už mimo aktuálny dátum. 

#### 2. Implementácia
Implementácia bola uskutočnená v IDE **XCode 10.1** na stroji s **MacOS 10.13 HighSierra**, avšak počas procesu implementácie zlyhal MacBook Air, takže projekt bol dokončený na virtualizovanom **MacOs Catalina 10.15 Beta** s **XCode 11.3**. Aplikácia bola vyvíjaná v **Swift 4.2** pre iPhone zariadenia s **iOS 12.1**.

##### 2.1 Storyboard
Aplikácia bola vytváraná v režime Storyboard - určuje rozloženie sekcií a aj dizajn užívateľského rozhrania. Jadro navigácie tvorí Tab Bar Controller, keďže aplikácia má 3 hlavné sekcie **Now**, **Med List** a **Settings**, prepínanie medzi nimi je pomocou tabov najrýchlejšie. Tab **Med List** je ďalej zabalený do Navigation Controlleru, keďže potrebuje zobraziť ďalšiu obrazovku. V Tabs sú vlastné ikony, ktoré boli pridané do *Assets.xcassets*

##### 2.2 Pill
Objekt so štruktúrou, ktoré informácie sa uchovávajú. 
```
var pillID: String                  // unikatne identifikacne cislo, sluzi na spravne ziskanie referencie
var name: String                    // nazov lieku
var dateBegin: String               // pociatocny datum uzivania
var dateEnd: String                 // konecny datum uzivania
var whenTake: String                // kedy je potrebne liek uzit
var state: PillState = .newPill     // default nastavenie stavu
let pillImage: UIImage? = nil  		// tvar a typ lieku
```

##### 2.3 ViewController
Vo ViewController je implementovaná práca s tabom **Now**. Pomocou funkcií _validDate_, _dayTime_ sa vyhodnocuje, do ktorého poľa sa liek zobrazí, teda či do _TakenPills UILabelu_, alebo do _NotTakenPills UILabelu_. 

##### 2.4 PillsTableViewController, PillTableViewCell
Spravuje tab **Med List** obsahuje bunky _PillTableViewCell_ s obrázkom, názvom lieku a časom kedy je ho potrebné užiť, komunikuje s databázou, _PillsData_ a uchováva pole _PillsDataSource_ do _medications_, zabezpečuje prepojenie na _PillDetailViewController_. Umožňuje presúvanie buniek, takisto aj mazanie.

##### 2.5 PillDetailViewController
Bližší detail view na objekt _Pill_ a umožňuje pridanie/úpravu informácií tohto objektu. Posiela signály o zmenách do pillsDatabase.

##### 2.6 SettingsViewController
Nastavenia ponúkajú zatiaľ len prepínanie posielania lokálnych uživateľských notifikácií. Uživateľské preferencie sa ukladajú do **UserDefaults**, nakoľko nepotrebujú ukladať veľké množstvo dát. Pri zostavovaní notifikačných triggers vo funkcií NotificationsTrigger sa vytvára aj pole _notificationID_, ktoré sa takisto ukladá do **UserDefaults** a slúži k tomu, že keď sa užívateľ rozhodne nezasielať tieto oznámenia, tak sa zo zariadenia vedia tieto nastavené triggers zrušiť.

##### 2.7 PillsData, PillsDatabase, Medications+CoreDataClass, Medications+CoreDataProperties
Ukladajú originál všetkých objektov Pill, ukladajú a načítavajú dáta z **CoreData** (entita **"Medications"**), rozposielajú a prijímajú notifikácie o zmene/vzniku objektu.

##### 3 Záver a testovanie
Aplikácia bola predstavená trom osobám s bežnými schopnosťami využívania technológií, 2 mladšie a 1 staršia. Nápad a myšlienka aplikácie im prišla užitočná a samotné predvedenie aplikácie považovali za dostatočné a použiteľné so zároveň jednoduchým ovládaním, avšak vedeli by si predstaviť rožšírenú funkčnosť o ďalšie schopnosti.
Pri samotnej tvorbe a implementácie aplikácie nenastali väčšie problémy až na v úvode spomínaný výpadok a zlyhanie stroju s HighSierra a tým pádom spojené určité obmedzenia, ktoré na virtualizovanom MacOS nastali.   






