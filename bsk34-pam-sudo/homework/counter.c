#include <ctype.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

static const size_t MAX_WORDS = 100000;
static const size_t LINE_LENGTH = 1048576;  // must be greater than 3 for security reasons
static const size_t STAT_NUM = 5;

struct word_counter_item {
    char *word;
    size_t counter;
};

static struct word_counter_item counter[MAX_WORDS];
size_t counter_next;

static char tmp_line[LINE_LENGTH];

static char first_line[LINE_LENGTH];

static void free_counter() {
    for (size_t i = 0; i < counter_next; ++i) {
        free(counter[i].word);
    }
    counter_next = 0;
}

static void replace_endline_with_zero(char *line, const size_t len) {
    size_t i;
    for (i = 0; i < len; ++i) {
        if (line[i] == '\n') {
            line[i] = '\0';
            return;
        }
    }
}

static void add_word(const char *word, size_t length) {
    for (size_t i = 0; i < counter_next; ++i) {
        if (strncmp(counter[i].word, word, length) == 0) {
            counter[i].counter += 1;
            return;
        }
    }

    if (counter_next >= MAX_WORDS) {
        fprintf(stderr, "Exceeded the limit of %d words per text. Exiting.", (int)MAX_WORDS);
        exit(EXIT_FAILURE);
    }

    char *word_copy = calloc(length + 1, sizeof(char));
    for (size_t i = 0; i < length; ++i) {
        word_copy[i] = word[i];
    }
    word_copy[length] = '\0';
    counter[counter_next].counter = 1;
    counter[counter_next].word = word_copy;
    counter_next += 1;
}

static void add_words_from_line(const char *line, const size_t length_limit) {
    size_t word_start = 0;
    size_t cur;

    for (cur = 0; cur < length_limit && line[cur]; cur++) {
        if (!isalpha(line[cur])) {
            if (word_start < cur) {
                add_word(line + word_start, cur - word_start);
            }
            word_start = cur + 1;
        }
    }
    if (word_start < cur) {
        add_word(line + word_start, cur - word_start);
    }
}

int compare_counter_items_rev(const void *a_void, const void *b_void) {
    const struct word_counter_item *a = a_void, *b = b_void;
    return -(a->counter - b->counter);
}

size_t min_size_t(size_t a, size_t b) {
    return (a < b)? a : b;
}

static void print_stats() {
    qsort(counter, counter_next, sizeof(counter[0]), compare_counter_items_rev);

    for (size_t i = 0; i < min_size_t(STAT_NUM, counter_next); ++i) {
        printf("%s ", counter[i].word);
    }
    printf("\n");
}

static void process_input(bool* input_finished) {
    counter_next = 0;

    bool no_input = true;

    while (fgets(tmp_line, (int) LINE_LENGTH, stdin)) {
        replace_endline_with_zero(tmp_line, LINE_LENGTH);
        if (strncmp(tmp_line, "==", 3) == 0) {
            if (no_input) {
                fprintf(stderr, "Empty text.\n");

                free_counter();
                return;
            } else {
                printf("%s\n", first_line);
                print_stats();

                free_counter();
                return;
            }
        } else {
            add_words_from_line(tmp_line, LINE_LENGTH);
        }

        if (no_input) {
            strncpy(first_line, tmp_line, LINE_LENGTH);
        }

        no_input = false;
    }

    *input_finished = true;
    if (feof(stdin) == 0) {
        fprintf(stderr, "An error has occured while reading stdin. Exiting.\n");
        exit(EXIT_FAILURE);
    } else {
        if (!no_input) {
            fprintf(stderr, "EOF while reading text. Exiting.\n");
            exit(EXIT_FAILURE);
        }
    }
}

int main() {
    bool input_finished = false;
    while (!input_finished) {
        process_input(&input_finished);
    }

    return 0;
}
