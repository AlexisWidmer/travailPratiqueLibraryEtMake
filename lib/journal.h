#ifndef _LIBJOURNAL_JOURNAL_H_
#define _LIBJOURNAL_JOURNAL_H_

#include <stdarg.h>
#include <stdio.h>
#include <time.h>

/** Énumération des différents niveaux de criticité de journalisation.
 *
 * Chaque énumération peut être convertie en chaîne de caractère grâce à la
 * structure de données niveau_vers_chaine[].
 *
 * @see niveau_vers_chaine[]
 **/
typedef enum {
    NONE = 0,
    ERROR = 1,
    WARNING = 2,
    INFO = 3,
    DEBUG = 4,
} niveau_t;

/** Tableau de chaînes assurant la conversion niveau de criticité => texte
 *
 **/
static char *niveau_vers_chaine[] = {
    NULL,
    "ERROR",
    "WARNING",
    "INFO",
    "DEBUG",
};

/** Initialise la journalisation.
 *
 * @param niveau Tout futur appel à ecrire_entree_journal() ne journalisera
 * qu'à un niveau inférieur ou égal à ce niveau de criticité.
 * @param nom_fichier La chaîne de caractères définissant le chemin du fichier de
 * journalisation.
 * @param fichier Pointeur sur FILE d'un fichier déjà déclaré.
 * @param ajouter Mode ajout au fichier si différent de 0, mode écrasé si égal à 0.
 *
 * @return 0 si tout va bien, -1 sinon
 *
 * @see ecrire_entree_journal
 **/
int ouvrir_journal(niveau_t niveau, char* nom_fichier, FILE* fichier, int ajouter);

/** Écrit une entrée dans le fichier de journalisation.
 *
 * Ne peut être appellé SI ET SEULEMENT SI ouvrir_journal a été appelé et n'a pas
 * retourné d'erreur.
 *
 * @param niveau Le niveau de criticité de l'entrée à journaliser
 * @param fichier Une chaîne décrivant le fichier réalisant l'entrée. __FILE__ est
 * sans nul doute ce que vous préféreriez saisir.
 * @param ligne Un nombre décrivant le numéro de la ligne réalisant l'entrée. __LINE__
 * est sans nul doute ce que vous préféreriez saisir.
 * @param format La chaîne de caractères spécifiant le message à journaliser formatée
 * comme une 'printf format string'.
 *
 * @see JOURNAL
 **/
void ecrire_entree_journal(niveau_t niveau, char* fichier, int ligne, char* format, ...);

/** MACRO permettant de faciliter l'ajout d'une entrée au journal.
 *
 * Cette MACRO fournie une interface simplifiée à ecrire_entree_journal()
 * en passant les définitions \__FILE__ et \__LINE__ correspondant toutes deux
 * au fichier appelant la MACRO et le numéro de ligne d'appel à la MACRO,
 * respectivement.
 *
 * @param niveau Le niveau de criticité de l'entrée.
 * @param args La chaîne de caractères spécifiant le message à journaliser
 * (accompagnée des variables si nécessaire).
 * 
 * @see ecrire_entree_journal()
 **/
#define JOURNAL(niveau, args...) \
    ecrire_entree_journal(niveau, __FILE__, __LINE__, args)

/** Termine l'utilisation possible de la journalisation.
 *
 * Clos le fichier de journalisation et empêche tout ajout d'une nouvelle entrée
 * au journal.
 * 
 * @see ouvrir_journal()
 **/
void fermer_journal(void);

#endif
