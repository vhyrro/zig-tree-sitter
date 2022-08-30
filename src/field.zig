// TODO: Would it ever be possible to make fields of a language an iterator?

const api = @import("api/out.zig");
const Language = @import("language.zig").Language;

pub const FieldID = api.TSFieldId;

pub const Field = struct {
    id: FieldID,
    name: []const u8,

    fn init_id(language: Language, id: FieldID) Field {
        return .{
            .id = id,
            .name = api.ts_language_field_name_for_id(language.language, id),
        };
    }

    fn init_name(language: Language, name: []const u8) Field {
        return .{
            .id = api.ts_language_field_id_for_name(language.language, name),
            .name = name,
        };
    }
};
