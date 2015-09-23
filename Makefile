#Les variables automatiques :
#$@ valeur du  target
#$< nom du premier pré-requis associé au target
#$? nom des pré-requis plus récent que le target
#$^ liste sans répétition des pré-requis
#$+ comme $^ mais avec les répétitions
#$* nom du target avec le suffix tronqué

#Variables pour faciliter la saisie et les modifications dans le Makefile :
#Variable pour le compilateur
CC ?= gcc

#Variable où aller chercher les fichiers
VPATH = lib:build:bin

#Variables pour la confection de la librairie :
#Options pour les lignes de code faites pour la confection des fichiers objets
DIROBJ := bin/
CFLAGS += -fPIC -Wall
OBJETS = $(FICHIERSC:.c=.o)
FICHIERSC = journal.c

#Nom du programme principal
PROGRPRINC = main.o

#Noms des librairies statiques et dynamiques
DIRLIB := build/
LINKNAME ?= journal
libSTATIC := lib$(LINKNAME).a
MAJEUR ?= .1
MINEUR ?= .1
CORRECTION ?= .57
SONAMECOURT := lib$(LINKNAME).so
SONAME := $(SONAMECOURT)$(MAJEUR)
REALNAME := $(SONAME)$(MINEUR)$(CORRECTION)

#Options pour les librairies
libCFLAGS = -shared -fPIC -Wl,-soname,
libLDFLAGS = -L.
libLDLIBS = -lc

#Options pour l'archive
ARFLAGS = rcs

#Options des programmes en statique et dynamique
STATIC = programme.static
DYNAMIC = programme.shared
sharedLDFLAGS := -L.
sharedLDLIBS := -l$(LINKNAME)
staticLDFLAGS := -L.
staticLDLIBS := -l:$(libSTATIC)

#Conception du Makefile :
#Execution de toutes les commandes les unes à la suite des autres
all: | MOVE execution

#Création des dossiers
MKDIR: lib/journal.c
	-mkdir build bin

#Fabrication du fichier objet addition.o
$(OBJETS): CFLAGS := $(CFLAGS)
$(OBJETS): $(FICHIERSC) MKDIR

#Fabrication du fichier objet main.o
$(PROGRPRINC): LDFLAGS := $(CFLAGS)

#Conception de l'archive pour la bibliothèque statique
$(libSTATIC)($(OBJETS)): ARFLAGS := $(ARFLAGS)
$(libSTATIC)($(OBJETS)): $(OBJETS)

#Règle pour appeler la conception de l'archive
$(libSTATIC): $(libSTATIC)($(OBJETS))

#Conception de la bibliothèque dynamique avec ses 2 liens symboliques
$(REALNAME): $(OBJETS)
	$(CC) $(libCFLAGS)$(SONAME) -o $@ $^
	ln -sf $@ $(SONAMECOURT)
	ln -sf $@ $(SONAME)

#Génération du programme dynamique
$(DYNAMIC): LDFLAGS := $(sharedLDFLAGS)
$(DYNAMIC): LDLIBS := $(sharedLDLIBS)
$(DYNAMIC): $(REALNAME) $(PROGRPRINC)
	$(CC) -o $@ $(PROGRPRINC) $(sharedLDFLAGS) $(sharedLDLIBS)

#Execution du programme dynamique
execution: $(DYNAMIC)
	-LD_LIBRARY_PATH=./$(DIRLIB):$LD_LIBRARY_PATH ./$(DIRLIB)$(DYNAMIC)

#Move les fichiers dans leur dossier respectif : .so .a et executable dans le dossier build. .o dans le dossier bin
MOVE: $(DYNAMIC) $(libSTATIC)
	-mv *libjournal* *programme* ./build/
	-mv *.o ./bin/

#Efface tout les fichiers créés dans le répertoire courant
clean: cleanNewDir
# -rm *.a *.o *.so* *programme* *.log

# #Efface tout les fichiers créés dans le dossier lib au cas où un fichier soit dedans
# cleanLib:
# 	-rm lib/*.a lib/*.o lib/*.so* lib/*programme* lib/*.log

#Efface tout les dossier build et bin ainsi que leur contenu
cleanNewDir:
	-rm -R build/ bin/