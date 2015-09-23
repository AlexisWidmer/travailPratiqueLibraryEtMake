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
DIROBJ := build/
CFLAGS += -fPIC -Wall
OBJETS = $(FICHIERSC:.c=.o)
FICHIERSC = journal.c

#Nom du programme principal
PROGRPRINC = main.o

#Noms des librairies statiques et dynamiques
DIRLIB := bin/
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
#Création des dossiers
MKDIR:
	-mkdir build bin

#Fabrication du fichier objet addition.o
$(OBJETS): CFLAGS := $(CFLAGS)
$(OBJETS): $(FICHIERSC) MKDIR

#Conception de l'archive pour la bibliothèque statique
$(libSTATIC)($(OBJETS)): ARFLAGS := $(ARFLAGS)
$(libSTATIC)($(OBJETS)): $(OBJETS)

#Règle pour appeler la conception de l'archive
$(libSTATIC): $(libSTATIC)($(OBJETS))

clean: cleanLib cleanNewDir
	-rm *.a *.o *.so* *programme*

cleanLib:
	-rm lib/*.a lib/*.o lib/*.so* lib/*programme*

cleanNewDir:
	-rm -R build/ bin/