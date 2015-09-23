#include "journal.h"

static FILE *journal;
static niveau_t niveau_journalisation;

int ouvrir_journal(niveau_t niveau, char* nom_fichier, FILE* fichier, int ajouter) {
    if (nom_fichier != NULL) {
        if (fichier != NULL) {
            return -1;
        }
        journal = fopen(nom_fichier, ajouter ? "a" : "w");
        if (journal == NULL) {
            return -1;
        }
    } else if (fichier != NULL) {
        journal = fichier;
    } else {
        return -1;
    }
    niveau_journalisation = niveau;
    return 0;
}

void ecrire_entree_journal(niveau_t niveau, char* fichier, int ligne, char* format, ...) {
    if (niveau > niveau_journalisation || journal == NULL) {
        return;
    }

    struct tm * timeinfo;
    time_t rawtime;
    char buffer [20];
    time (&rawtime);
    timeinfo = localtime (&rawtime);
    strftime(buffer,20,"%Y-%d-%m %H:%M:%S",timeinfo);

    fprintf(journal, "[%s] ", buffer);

    if (niveau_journalisation == DEBUG) {
        fprintf(journal, "%s:%d:", fichier, ligne);
    }

    fprintf(journal, "%s: ", niveau_vers_chaine[niveau]);

    va_list ap;
    va_start(ap, format);
    vfprintf(journal, format, ap);
    va_end(ap);
    fprintf(journal, "\n");

    if (niveau_journalisation == DEBUG) {
        fflush(journal);
    }
}

void fermer_journal(void) {
    fclose(journal);
    journal = NULL;
}
