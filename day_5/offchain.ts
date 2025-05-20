import { Data } from "@lucid-evolution/lucid";

/** Aiken code:
 * ```aiken
 * pub type EnumType {
 *    Red
 *    Green
 *    Blue
 * }
 * ```
 */
const EnumTypeSchema =
  Data.Enum([
    Data.Literal("Red"),
    Data.Literal("Green"),
    Data.Literal("Blue"),
  ]);

/** Aiken code:
 * ```aiken
 * /// `SubType` is a single-constructor type with 2 fields.
 * pub type SubType {
 *    sub_field1: Bool,
 *    sub_field2: (Int, ByteArray)
 * }
 * ```
 */
const SubTypeSchema =
  Data.Object({
    subField1: Data.Boolean(),
    subField2: Data.Tuple([Data.Integer(), Data.Bytes()]),
  });
type SubDatumType = Data.Static<typeof SubTypeSchema>;
const SubDatumType = SubTypeSchema as unknown as SubDatumType;

/** Aiken code:
 * ```aiken
 * /// `Datum` is a single-constructor type.
 * pub type Datum {
 *    field1: Bool,
 *    field2: (Int, ByteArray),
 *    field3: SubType,
 *    field4: EnumType,
 * }
 * ```
 */
const DatumSchema =
  Data.Object({
    field1: Data.Integer(),
    field2: Data.Bytes(),
    field3: SubTypeSchema,
    field4: EnumTypeSchema,
  });
type DatumType = Data.Static<typeof DatumSchema>;
const DatumType = DatumSchema as unknown as DatumType;

/** Aiken code:
 * ```aiken
 * List<MyDatum>
 * ```
 */
const ListType =
  Data.Array(DatumSchema);

/** Aiken code:
 * ```aiken
 * Pairs<ByteArray, MyDatum>
 * ```
 */
const MapType =
  Data.Map(Data.Bytes(), DatumSchema);

/** Aiken code:
 * ```aiken
 * Option<MyDatum>
 * ```
 */
const OptionType =
  Data.Nullable(DatumSchema);
