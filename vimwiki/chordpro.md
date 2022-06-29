## ChordPro
{title: title string} ({t:string})
Specifies the title of the song. The title is used to sort the songs in the user interface. It appears at the top of the song, centered, and may be repeated if the song overflows onto a new column.
{subtitle: subtitle string} ({su:string})
Specifies a subtitle for the song. This string will be printed just below the title string.
{start_of_chorus} ({soc})
Indicates the start of a chorus. Songsheet Generator can apply a special marking to highlight the chorus, depending on the setting of the output destination. The marking is applied until the end_of_chorus directive appears.
{end_of_chorus} ({eoc})
Marks the end of a chorus.
{comment: string} ({c:string})
Prints the string following the colon as a comment.
{start_of_tab} ({sot})
Indicates the start of a guitar tab section. The text will be formatted in a fixed-width font until the end_of_tab directive appears. This can be useful for creating a tab drawing with ASCII text. Guitar tab sections will only be printed if chords are also printed.
{end_of_tab} ({eot})
Marks the end of the guitar tab section.
{guitar_comment: string} ({gc:string})
Prints the string following the colon as a comment. This comment will only be printed if chords are also printed; it should be used for comments to performers, or for other notes that are unneccessary for lyrics-only song sheets (or projection).
{new_song} ({ns})
Marks the beginning of a new song. Although this directive will work with the Songsheet Generator program, its use is not recommended, since only the first song in any song file will show up in the "Songs available" list.
{new_page} ({np})
This directive will cause a "cell break" in the Two and Four Discrete Cells per Page printing modes, and a column break in the Two Flowing Columns printing mode. It will cause a physical page break otherwise. It has no effect in the Text and HTML File output destinations.
{new_physical_page} ({npp})
This directive will always force a physical page break. It has no effect in the Text and HTML File output destinations.
{column_break} ({colb})
This directive will force a column break in the Flowing Columns printing modes, which amounts to a physical page break in the One Flowing Column printing mode. It has no effect in the Discrete Cells printing modes, and no effect in the Text and HTML File output destinations.
{data_abc: xyz} ({d_abc:xyz})
Data key and value; abc is the key, xyz is its value. 
Note: this is a Songsheet Generator extension to the standard syntax.
{footer: xyz} ({f:xyz})
Footer override for the current song. 
Note: this is a Songsheet Generator extension to the standard syntax.
{key: xyz} ({k:xyz})
Key the chart is written in; xyz is a valid key; transposition will apply. 
Note: this is a Songsheet Generator extension to the standard syntax.
Chords

Chords are delimited by square brackets ('[' and ']'). Sharp is indicated by a '#' (hash) and flat by a 'b' (lowercase 'B'). Songsheet Generator recognizes chords of the following form:

[A-G]{#|b}{m|dim|maj|sus}{digit}{/[A-G]{#|b}}
i.e. [A] [C#m7] [Bb/D]
Chord Grids

A large number of common chord grids have been built into the Songsheet Generator executable. Additional chord grids may be defined in song files, via the standard ChordPro chord grid definition syntax:

{define: <chord> base-fret <base> frets <Low-E> <A> <D> <G> <B> <E>}
For example:
{define: E5 base-fret 7 frets 0 1 3 3 x x}
In addition, an extension to the standard format is recognized by Songsheet Generator, which adds fingering support to the grid. Fingerings are printed below the chord grids. The syntax for the fingering definition follows:

{define: <chord> base-fret <base> frets <Low-E> <A> <D> <G> <B> <E> fingers <Low-E> <A> <D> <G> <B> <E>}
For example:
{define: E5 base-fret 7 frets 0 1 3 3 x x fingers - 1 2 3 - -}
It is also possible to define the key for which the chord definition applies. This can be useful when a particular chord fingering is only relevant when playing a song in a particular key. When defined in this way, chords will revert to the standard definition when the song is transposed (or, to another chord defined for the transposed-to key signature). This is optional; when the "key" keyword is not added to the chord definition, the chord definition will apply to all keys. The complete chord definition syntax recognized by Songsheet Generator is:

{define: <chord> base-fret <base> frets <Low-E> <A> <D> <G> <B> <E> fingers <Low-E> <A> <D> <G> <B> <E> key <KEY>}
For example: {define: E5 base-fret 7 frets 0 1 3 3 x x fingers - 1 2 3 - - key E}
Note: The first base-fret is 1 (one), not 0 (zero). 
Also note: Chords grids defined in songs will override any built-in definitions. 
Also also note: All of Songsheet Generator's built-in chord definitions still apply to all keys. 
Also also also note: global chords may be defined using the Custom Chord Editor.

Comments in the file

Lines in the file that have '#' as the first character are considered comments and will never be printed.
