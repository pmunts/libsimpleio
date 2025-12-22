pragma Ada_2012;

pragma Style_Checks (Off);
pragma Warnings (Off, "-gnatwu");

with Interfaces; use Interfaces;
with Interfaces.C; use Interfaces.C;
with Interfaces.C.Strings;
with System;

--  Merged thin binding for librabbitmq (rabbitmq-c)
--  Auto-generated from amqp.h and amqp_framing.h, then merged to resolve circular deps
package RabbitMQ.C_Binding is

   --  ===========================================
   --  From amqp.h (base types and API functions)
   --  ===========================================

--  unsupported macro: AMQP_BEGIN_DECLS extern "C" {
   --  unsupported macro: AMQP_END_DECLS }
   --  unsupported macro: AMQP_PUBLIC_FUNCTION __attribute__((visibility("default")))
   --  unsupported macro: AMQP_PUBLIC_VARIABLE __attribute__((visibility("default"))) extern
   --  arg-macro: procedure AMQP_DEPRECATED (function)
   --    function __attribute__((__deprecated__))
   AMQP_VERSION_MAJOR : constant := 0;  --  /usr/include/amqp.h:221
   AMQP_VERSION_MINOR : constant := 11;  --  /usr/include/amqp.h:222
   AMQP_VERSION_PATCH : constant := 0;  --  /usr/include/amqp.h:223
   AMQP_VERSION_IS_RELEASE : constant := 1;  --  /usr/include/amqp.h:224
   --  arg-macro: function AMQP_VERSION_CODE (major, minor, patch, release)
   --    return (major << 24) or (minor << 16) or (patch << 8) or (release);
   --  unsupported macro: AMQP_VERSION AMQP_VERSION_CODE(AMQP_VERSION_MAJOR, AMQP_VERSION_MINOR, AMQP_VERSION_PATCH, AMQP_VERSION_IS_RELEASE)
   --  arg-macro: procedure AMQ_STRINGIFY (s)
   --    AMQ_STRINGIFY_HELPER(s)
   --  unsupported macro: AMQ_STRINGIFY_HELPER(s) #s
   --  unsupported macro: AMQ_VERSION_STRING AMQ_STRINGIFY(AMQP_VERSION_MAJOR) "." AMQ_STRINGIFY(AMQP_VERSION_MINOR) "." AMQ_STRINGIFY(AMQP_VERSION_PATCH)
   --  unsupported macro: AMQP_VERSION_STRING AMQ_VERSION_STRING

   AMQP_DEFAULT_FRAME_SIZE : constant := 131072;  --  /usr/include/amqp.h:326

   AMQP_DEFAULT_MAX_CHANNELS : constant := 2047;  --  /usr/include/amqp.h:340

   AMQP_DEFAULT_HEARTBEAT : constant := 0;  --  /usr/include/amqp.h:351

   AMQP_DEFAULT_VHOST : aliased constant String := "/" & ASCII.NUL;  --  /usr/include/amqp.h:362
   --  unsupported macro: AMQP_EMPTY_BYTES amqp_empty_bytes
   --  unsupported macro: AMQP_EMPTY_TABLE amqp_empty_table
   --  unsupported macro: AMQP_EMPTY_ARRAY amqp_empty_array

  --* \file  
  -- * ***** BEGIN LICENSE BLOCK *****
  -- * Version: MIT
  -- *
  -- * Portions created by Alan Antonuk are Copyright (c) 2012-2014
  -- * Alan Antonuk. All Rights Reserved.
  -- *
  -- * Portions created by VMware are Copyright (c) 2007-2012 VMware, Inc.
  -- * All Rights Reserved.
  -- *
  -- * Portions created by Tony Garnock-Jones are Copyright (c) 2009-2010
  -- * VMware, Inc. and Tony Garnock-Jones. All Rights Reserved.
  -- *
  -- * Permission is hereby granted, free of charge, to any person
  -- * obtaining a copy of this software and associated documentation
  -- * files (the "Software"), to deal in the Software without
  -- * restriction, including without limitation the rights to use, copy,
  -- * modify, merge, publish, distribute, sublicense, and/or sell copies
  -- * of the Software, and to permit persons to whom the Software is
  -- * furnished to do so, subject to the following conditions:
  -- *
  -- * The above copyright notice and this permission notice shall be
  -- * included in all copies or substantial portions of the Software.
  -- *
  -- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
  -- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  -- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
  -- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
  -- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
  -- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
  -- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  -- * SOFTWARE.
  -- * ***** END LICENSE BLOCK *****
  --  

  --* \cond HIDE_FROM_DOXYGEN  
  -- * \internal
  -- * Important API decorators:
  -- *  AMQP_PUBLIC_FUNCTION - a public API function
  -- *  AMQP_PUBLIC_VARIABLE - a public API external variable
  -- *  AMQP_CALL - calling convension (used on Win32)
  --  

  -- Define ssize_t on Win32/64 platforms
  --   See: http://lists.cs.uiuc.edu/pipermail/llvmdev/2010-April/030649.html for
  --   details
  --    

  --* \endcond  
   type timeval is null record;   -- incomplete struct

  --*
  -- * \def AMQP_VERSION_MAJOR
  -- *
  -- * Major library version number compile-time constant
  -- *
  -- * The major version is incremented when backwards incompatible API changes
  -- * are made.
  -- *
  -- * \sa AMQP_VERSION, AMQP_VERSION_STRING
  -- *
  -- * \since v0.4.0
  --  

  --*
  -- * \def AMQP_VERSION_MINOR
  -- *
  -- * Minor library version number compile-time constant
  -- *
  -- * The minor version is incremented when new APIs are added. Existing APIs
  -- * are left alone.
  -- *
  -- * \sa AMQP_VERSION, AMQP_VERSION_STRING
  -- *
  -- * \since v0.4.0
  --  

  --*
  -- * \def AMQP_VERSION_PATCH
  -- *
  -- * Patch library version number compile-time constant
  -- *
  -- * The patch version is incremented when library code changes, but the API
  -- * is not changed.
  -- *
  -- * \sa AMQP_VERSION, AMQP_VERSION_STRING
  -- *
  -- * \since v0.4.0
  --  

  --*
  -- * \def AMQP_VERSION_IS_RELEASE
  -- *
  -- * Version constant set to 1 for tagged release, 0 otherwise
  -- *
  -- * NOTE: versions that are not tagged releases are not guaranteed to be API/ABI
  -- * compatible with older releases, and may change commit-to-commit.
  -- *
  -- * \sa AMQP_VERSION, AMQP_VERSION_STRING
  -- *
  -- * \since v0.4.0
  --  

  -- * Developer note: when changing these, be sure to update SOVERSION constants
  -- *  in CMakeLists.txt and configure.ac
  --  

  --*
  -- * \def AMQP_VERSION_CODE
  -- *
  -- * Helper macro to geneate a packed version code suitable for
  -- * comparison with AMQP_VERSION.
  -- *
  -- * \sa amqp_version_number() AMQP_VERSION_MAJOR, AMQP_VERSION_MINOR,
  -- *     AMQP_VERSION_PATCH, AMQP_VERSION_IS_RELEASE, AMQP_VERSION
  -- *
  -- * \since v0.6.1
  --  

  --*
  -- * \def AMQP_VERSION
  -- *
  -- * Packed version number
  -- *
  -- * AMQP_VERSION is a 4-byte unsigned integer with the most significant byte
  -- * set to AMQP_VERSION_MAJOR, the second most significant byte set to
  -- * AMQP_VERSION_MINOR, third most significant byte set to AMQP_VERSION_PATCH,
  -- * and the lowest byte set to AMQP_VERSION_IS_RELEASE.
  -- *
  -- * For example version 2.3.4 which is released version would be encoded as
  -- * 0x02030401
  -- *
  -- * \sa amqp_version_number() AMQP_VERSION_MAJOR, AMQP_VERSION_MINOR,
  -- *     AMQP_VERSION_PATCH, AMQP_VERSION_IS_RELEASE, AMQP_VERSION_CODE
  -- *
  -- * \since v0.4.0
  --  

  --* \cond HIDE_FROM_DOXYGEN  
  --* \endcond  
  --*
  -- * \def AMQP_VERSION_STRING
  -- *
  -- * Version string compile-time constant
  -- *
  -- * Non-released versions of the library will have "-pre" appended to the
  -- * version string
  -- *
  -- * \sa amqp_version()
  -- *
  -- * \since v0.4.0
  --  

  --*
  -- * Returns the rabbitmq-c version as a packed integer.
  -- *
  -- * See \ref AMQP_VERSION
  -- *
  -- * \return packed 32-bit integer representing version of library at runtime
  -- *
  -- * \sa AMQP_VERSION, amqp_version()
  -- *
  -- * \since v0.4.0
  --  

   function amqp_version_number return Unsigned_32  -- /usr/include/amqp.h:301
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_version_number";

  --*
  -- * Returns the rabbitmq-c version as a string.
  -- *
  -- * See \ref AMQP_VERSION_STRING
  -- *
  -- * \return a statically allocated string describing the version of rabbitmq-c.
  -- *
  -- * \sa amqp_version_number(), AMQP_VERSION_STRING, AMQP_VERSION
  -- *
  -- * \since v0.1
  --  

   function amqp_version return Interfaces.C.Strings.chars_ptr  -- /usr/include/amqp.h:315
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_version";

  --*
  -- * \def AMQP_DEFAULT_FRAME_SIZE
  -- *
  -- * Default frame size (128Kb)
  -- *
  -- * \sa amqp_login(), amqp_login_with_properties()
  -- *
  -- * \since v0.4.0
  --  

  --*
  -- * \def AMQP_DEFAULT_MAX_CHANNELS
  -- *
  -- * Default maximum number of channels (2047, RabbitMQ default limit of 2048,
  -- * minus 1 for channel 0). RabbitMQ set a default limit of 2048 channels per
  -- * connection in v3.7.5 to prevent broken clients from leaking too many
  -- * channels.
  -- *
  -- * \sa amqp_login(), amqp_login_with_properties()
  -- *
  -- * \since v0.4.0
  --  

  --*
  -- * \def AMQP_DEFAULT_HEARTBEAT
  -- *
  -- * Default heartbeat interval (0, heartbeat disabled)
  -- *
  -- * \sa amqp_login(), amqp_login_with_properties()
  -- *
  -- * \since v0.4.0
  --  

  --*
  -- * \def AMQP_DEFAULT_VHOST
  -- *
  -- * Default RabbitMQ vhost: "/"
  -- *
  -- * \sa amqp_login(), amqp_login_with_properties()
  -- *
  -- * \since v0.9.0
  --  

  --*
  -- * boolean type 0 = false, true otherwise
  -- *
  -- * \since v0.1
  --  

   subtype amqp_boolean_t is int;  -- /usr/include/amqp.h:369

  --*
  -- * Method number
  -- *
  -- * \since v0.1
  --  

   subtype amqp_method_number_t is Unsigned_32;  -- /usr/include/amqp.h:376

  --*
  -- * Bitmask for flags
  -- *
  -- * \since v0.1
  --  

   subtype amqp_flags_t is Unsigned_32;  -- /usr/include/amqp.h:383

  --*
  -- * Channel type
  -- *
  -- * \since v0.1
  --  

   subtype amqp_channel_t is Unsigned_16;  -- /usr/include/amqp.h:390

  --*
  -- * Buffer descriptor
  -- *
  -- * \since v0.1
  --  

  --*< length of the buffer in bytes  
   type amqp_bytes_t_u is record
      len : aliased size_t;  -- /usr/include/amqp.h:398
      bytes : System.Address;  -- /usr/include/amqp.h:399
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp.h:397

  --*< pointer to the beginning of the buffer  
   subtype amqp_bytes_t is amqp_bytes_t_u;  -- /usr/include/amqp.h:400

  --*
  -- * Decimal data type
  -- *
  -- * \since v0.1
  --  

  --*< the location of the decimal point  
   type amqp_decimal_t_u is record
      decimals : aliased Unsigned_8;  -- /usr/include/amqp.h:408
      value : aliased Unsigned_32;  -- /usr/include/amqp.h:409
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp.h:407

  --*< the value before the decimal point is applied  
   subtype amqp_decimal_t is amqp_decimal_t_u;  -- /usr/include/amqp.h:410

  --*
  -- * AMQP field table
  -- *
  -- * An AMQP field table is a set of key-value pairs.
  -- * A key is a UTF-8 encoded string up to 128 bytes long, and are not null
  -- * terminated.
  -- * A value can be one of several different datatypes. \sa
  -- * amqp_field_value_kind_t
  -- *
  -- * \sa amqp_table_entry_t
  -- *
  -- * \since v0.1
  --  

  --*< length of entries array  
   type amqp_table_entry_t_u;
   type amqp_table_t_u is record
      num_entries : aliased int;  -- /usr/include/amqp.h:426
      entries : access amqp_table_entry_t_u;  -- /usr/include/amqp.h:427
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp.h:425

  --*< an array of table entries  
   subtype amqp_table_t is amqp_table_t_u;  -- /usr/include/amqp.h:428

  --*
  -- * An AMQP Field Array
  -- *
  -- * A repeated set of field values, all must be of the same type
  -- *
  -- * \since v0.1
  --  

  --*< Number of entries in the table  
   type amqp_field_value_t_u;
   type amqp_array_t_u is record
      num_entries : aliased int;  -- /usr/include/amqp.h:438
      entries : access amqp_field_value_t_u;  -- /usr/include/amqp.h:439
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp.h:437

  --*< linked list of field values  
   subtype amqp_array_t is amqp_array_t_u;  -- /usr/include/amqp.h:440

  --  0-9   0-9-1   Qpid/Rabbit  Type               Remarks
  -----------------------------------------------------------------------------
  --        t       t            Boolean
  --        b       b            Signed 8-bit
  --        B                    Unsigned 8-bit
  --        U       s            Signed 16-bit      (A1)
  --        u                    Unsigned 16-bit
  --  I     I       I            Signed 32-bit
  --        i                    Unsigned 32-bit
  --        L       l            Signed 64-bit      (B)
  --        l                    Unsigned 64-bit
  --        f       f            32-bit float
  --        d       d            64-bit float
  --  D     D       D            Decimal
  --        s                    Short string       (A2)
  --  S     S       S            Long string
  --        A                    Nested Array
  --  T     T       T            Timestamp (u64)
  --  F     F       F            Nested Table
  --  V     V       V            Void
  --                x            Byte array
  --Remarks:
  -- A1, A2: Notice how the types **CONFLICT** here. In Qpid and Rabbit,
  --         's' means a signed 16-bit integer; in 0-9-1, it means a
  --          short string.
  -- B: Notice how the signednesses **CONFLICT** here. In Qpid and Rabbit,
  --    'l' means a signed 64-bit integer; in 0-9-1, it means an unsigned
  --    64-bit integer.
  --I'm going with the Qpid/Rabbit types, where there's a conflict, and
  --the 0-9-1 types otherwise. 0-8 is a subset of 0-9, which is a subset
  --of the other two, so this will work for both 0-8 and 0-9-1 branches of
  --the code.
  -- 

  --*
  -- * A field table value
  -- *
  -- * \since v0.1
  --  

  --*< the type of the entry /sa amqp_field_value_kind_t  
   type anon_anon_2 (discr : unsigned := 0) is record
      case discr is
         when 0 =>
            boolean : aliased amqp_boolean_t;  -- /usr/include/amqp.h:489
         when 1 =>
            i8 : aliased Integer_8;  -- /usr/include/amqp.h:490
         when 2 =>
            u8 : aliased Unsigned_8;  -- /usr/include/amqp.h:491
         when 3 =>
            i16 : aliased Integer_16;  -- /usr/include/amqp.h:492
         when 4 =>
            u16 : aliased Unsigned_16;  -- /usr/include/amqp.h:493
         when 5 =>
            i32 : aliased Integer_32;  -- /usr/include/amqp.h:494
         when 6 =>
            u32 : aliased Unsigned_32;  -- /usr/include/amqp.h:495
         when 7 =>
            i64 : aliased Integer_64;  -- /usr/include/amqp.h:496
         when 8 =>
            u64 : aliased Unsigned_64;  -- /usr/include/amqp.h:497
         when 9 =>
            f32 : aliased float;  -- /usr/include/amqp.h:499
         when 10 =>
            f64 : aliased double;  -- /usr/include/amqp.h:500
         when 11 =>
            decimal : aliased amqp_decimal_t;  -- /usr/include/amqp.h:501
         when 12 =>
            bytes : aliased amqp_bytes_t;  -- /usr/include/amqp.h:502
         when 13 =>
            table : aliased amqp_table_t;  -- /usr/include/amqp.h:504
         when others =>
            c_array : aliased amqp_array_t;  -- /usr/include/amqp.h:505
      end case;
   end record
   with Convention => C_Pass_By_Copy,
        Unchecked_Union => True;
   type amqp_field_value_t_u is record
      kind : aliased Unsigned_8;  -- /usr/include/amqp.h:487
      value : aliased anon_anon_2;  -- /usr/include/amqp.h:506
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp.h:486

  --*< boolean type AMQP_FIELD_KIND_BOOLEAN  
  --*< int8_t type AMQP_FIELD_KIND_I8  
  --*< uint8_t type AMQP_FIELD_KIND_U8  
  --*< int16_t type AMQP_FIELD_KIND_I16  
  --*< uint16_t type AMQP_FIELD_KIND_U16  
  --*< int32_t type AMQP_FIELD_KIND_I32  
  --*< uint32_t type AMQP_FIELD_KIND_U32  
  --*< int64_t type AMQP_FIELD_KIND_I64  
  --*< uint64_t type AMQP_FIELD_KIND_U64,
  --                               AMQP_FIELD_KIND_TIMESTAMP  

  --*< float type AMQP_FIELD_KIND_F32  
  --*< double type AMQP_FIELD_KIND_F64  
  --*< amqp_decimal_t AMQP_FIELD_KIND_DECIMAL  
  --*< amqp_bytes_t type AMQP_FIELD_KIND_UTF8,
  --                               AMQP_FIELD_KIND_BYTES  

  --*< amqp_table_t type AMQP_FIELD_KIND_TABLE  
  --*< amqp_array_t type AMQP_FIELD_KIND_ARRAY  
  --*< a union of the value  
   subtype amqp_field_value_t is amqp_field_value_t_u;  -- /usr/include/amqp.h:507

  --*
  -- * An entry in a field-table
  -- *
  -- * \sa amqp_table_encode(), amqp_table_decode(), amqp_table_clone()
  -- *
  -- * \since v0.1
  --  

  --*< the table entry key. Its a null-terminated UTF-8
  --                     * string, with a maximum size of 128 bytes  

   type amqp_table_entry_t_u is record
      key : aliased amqp_bytes_t;  -- /usr/include/amqp.h:517
      value : aliased amqp_field_value_t;  -- /usr/include/amqp.h:519
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp.h:516

  --*< the table entry values  
   subtype amqp_table_entry_t is amqp_table_entry_t_u;  -- /usr/include/amqp.h:520

  --*
  -- * Field value types
  -- *
  -- * \since v0.1
  --  

  --*< boolean type. 0 = false, 1 = true @see amqp_boolean_t  
  --*< 8-bit signed integer, datatype: int8_t  
  --*< 8-bit unsigned integer, datatype: uint8_t  
  --*< 16-bit signed integer, datatype: int16_t  
  --*< 16-bit unsigned integer, datatype: uint16_t  
  --*< 32-bit signed integer, datatype: int32_t  
  --*< 32-bit unsigned integer, datatype: uint32_t  
  --*< 64-bit signed integer, datatype: int64_t  
  --*< 64-bit unsigned integer, datatype: uint64_t  
  --*< single-precision floating point value, datatype: float  
  --*< double-precision floating point value, datatype: double  
  --*< amqp-decimal value, datatype: amqp_decimal_t  
  --*< UTF-8 null-terminated character string,
  --                                      datatype: amqp_bytes_t  

  --*< field array (repeated values of another
  --                                      datatype. datatype: amqp_array_t  

  --*< 64-bit timestamp. datatype uint64_t  
  --*< field table. encapsulates a table inside a
  --                                  table entry. datatype: amqp_table_t  

  --*< empty entry  
  --*< unformatted byte string, datatype: amqp_bytes_t  
   subtype amqp_field_value_kind_t is unsigned;
   amqp_field_value_kind_t_AMQP_FIELD_KIND_BOOLEAN : constant amqp_field_value_kind_t := 116;
   amqp_field_value_kind_t_AMQP_FIELD_KIND_I8 : constant amqp_field_value_kind_t := 98;
   amqp_field_value_kind_t_AMQP_FIELD_KIND_U8 : constant amqp_field_value_kind_t := 66;
   amqp_field_value_kind_t_AMQP_FIELD_KIND_I16 : constant amqp_field_value_kind_t := 115;
   amqp_field_value_kind_t_AMQP_FIELD_KIND_U16 : constant amqp_field_value_kind_t := 117;
   amqp_field_value_kind_t_AMQP_FIELD_KIND_I32 : constant amqp_field_value_kind_t := 73;
   amqp_field_value_kind_t_AMQP_FIELD_KIND_U32 : constant amqp_field_value_kind_t := 105;
   amqp_field_value_kind_t_AMQP_FIELD_KIND_I64 : constant amqp_field_value_kind_t := 108;
   amqp_field_value_kind_t_AMQP_FIELD_KIND_U64 : constant amqp_field_value_kind_t := 76;
   amqp_field_value_kind_t_AMQP_FIELD_KIND_F32 : constant amqp_field_value_kind_t := 102;
   amqp_field_value_kind_t_AMQP_FIELD_KIND_F64 : constant amqp_field_value_kind_t := 100;
   amqp_field_value_kind_t_AMQP_FIELD_KIND_DECIMAL : constant amqp_field_value_kind_t := 68;
   amqp_field_value_kind_t_AMQP_FIELD_KIND_UTF8 : constant amqp_field_value_kind_t := 83;
   amqp_field_value_kind_t_AMQP_FIELD_KIND_ARRAY : constant amqp_field_value_kind_t := 65;
   amqp_field_value_kind_t_AMQP_FIELD_KIND_TIMESTAMP : constant amqp_field_value_kind_t := 84;
   amqp_field_value_kind_t_AMQP_FIELD_KIND_TABLE : constant amqp_field_value_kind_t := 70;
   amqp_field_value_kind_t_AMQP_FIELD_KIND_VOID : constant amqp_field_value_kind_t := 86;
   amqp_field_value_kind_t_AMQP_FIELD_KIND_BYTES : constant amqp_field_value_kind_t := 120;  -- /usr/include/amqp.h:554

  --*
  -- * A list of allocation blocks
  -- *
  -- * \since v0.1
  --  

  --*< Number of blocks in the block list  
   type amqp_pool_blocklist_t_u is record
      num_blocks : aliased int;  -- /usr/include/amqp.h:562
      blocklist : System.Address;  -- /usr/include/amqp.h:563
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp.h:561

  --*< Array of memory blocks  
   subtype amqp_pool_blocklist_t is amqp_pool_blocklist_t_u;  -- /usr/include/amqp.h:564

  --*
  -- * A memory pool
  -- *
  -- * \since v0.1
  --  

  --*< the size of the page in bytes. Allocations less than or
  --                    * equal to this size are allocated in the pages block list.
  --                    * Allocations greater than this are allocated in their own
  --                    * own block in the large_blocks block list  

   type amqp_pool_t_u is record
      pagesize : aliased size_t;  -- /usr/include/amqp.h:572
      pages : aliased amqp_pool_blocklist_t;  -- /usr/include/amqp.h:577
      large_blocks : aliased amqp_pool_blocklist_t;  -- /usr/include/amqp.h:578
      next_page : aliased int;  -- /usr/include/amqp.h:581
      alloc_block : Interfaces.C.Strings.chars_ptr;  -- /usr/include/amqp.h:582
      alloc_used : aliased size_t;  -- /usr/include/amqp.h:583
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp.h:571

  --*< blocks that are the size of pagesize  
  --*< allocations larger than the pagesize
  --                                        

  --*< an index to the next unused page block  
  --*< pointer to the current allocation block  
  --*< number of bytes in the current allocation block that
  --                        has been used  

   subtype amqp_pool_t is amqp_pool_t_u;  -- /usr/include/amqp.h:585

  --*
  -- * An amqp method
  -- *
  -- * \since v0.1
  --  

  --*< the method id number  
   type amqp_method_t_u is record
      id : aliased amqp_method_number_t;  -- /usr/include/amqp.h:593
      decoded : System.Address;  -- /usr/include/amqp.h:594
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp.h:592

  --*< pointer to the decoded method,
  --                            *    cast to the appropriate type to use  

   subtype amqp_method_t is amqp_method_t_u;  -- /usr/include/amqp.h:596

  --*
  -- * An AMQP frame
  -- *
  -- * \since v0.1
  --  

  --*< frame type. The types:
  --                           * - AMQP_FRAME_METHOD - use the method union member
  --                           * - AMQP_FRAME_HEADER - use the properties union member
  --                           * - AMQP_FRAME_BODY - use the body_fragment union member
  --                            

   type anon_anon_5 is record
      class_id : aliased Unsigned_16;  -- /usr/include/amqp.h:614
      body_size : aliased Unsigned_64;  -- /usr/include/amqp.h:615
      decoded : System.Address;  -- /usr/include/amqp.h:616
      raw : aliased amqp_bytes_t;  -- /usr/include/amqp.h:617
   end record
   with Convention => C_Pass_By_Copy;
   type anon_anon_6 is record
      transport_high : aliased Unsigned_8;  -- /usr/include/amqp.h:623
      transport_low : aliased Unsigned_8;  -- /usr/include/amqp.h:624
      protocol_version_major : aliased Unsigned_8;  -- /usr/include/amqp.h:625
      protocol_version_minor : aliased Unsigned_8;  -- /usr/include/amqp.h:626
   end record
   with Convention => C_Pass_By_Copy;
   type anon_anon_4 (discr : unsigned := 0) is record
      case discr is
         when 0 =>
            method : aliased amqp_method_t;  -- /usr/include/amqp.h:611
         when 1 =>
            properties : aliased anon_anon_5;  -- /usr/include/amqp.h:618
         when 2 =>
            body_fragment : aliased amqp_bytes_t;  -- /usr/include/amqp.h:620
         when others =>
            protocol_header : aliased anon_anon_6;  -- /usr/include/amqp.h:627
      end case;
   end record
   with Convention => C_Pass_By_Copy,
        Unchecked_Union => True;
   type amqp_frame_t_u is record
      frame_type : aliased Unsigned_8;  -- /usr/include/amqp.h:604
      channel : aliased amqp_channel_t;  -- /usr/include/amqp.h:609
      payload : aliased anon_anon_4;  -- /usr/include/amqp.h:629
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp.h:603

  --*< the channel the frame was received on  
  --*< a method, use if frame_type == AMQP_FRAME_METHOD
  --                            

  --*< the class for the properties  
  --*< size of the body in bytes  
  --*< the decoded properties  
  --*< amqp-encoded properties structure  
  --*< message header, a.k.a., properties,
  --                                      use if frame_type == AMQP_FRAME_HEADER  

  --*< a body fragment, use if frame_type ==
  --                                   AMQP_FRAME_BODY  

  --*< @internal first byte of handshake  
  --*< @internal second byte of handshake  
  --*< @internal third byte of handshake  
  --*< @internal fourth byte of handshake  
  --*< Used only when doing the initial handshake with the
  --                          broker, don't use otherwise  

  --*< the payload of the frame  
   subtype amqp_frame_t is amqp_frame_t_u;  -- /usr/include/amqp.h:630

  --*
  -- * Response type
  -- *
  -- * \since v0.1
  --  

   type amqp_response_type_enum_u is 
     (AMQP_RESPONSE_NONE,
      AMQP_RESPONSE_NORMAL,
      AMQP_RESPONSE_LIBRARY_EXCEPTION,
      AMQP_RESPONSE_SERVER_EXCEPTION)
   with Convention => C;  -- /usr/include/amqp.h:637

  --*< the library got an EOF from the socket  
  --*< response normal, the RPC completed successfully  
  --*< library error, an error occurred in the
  --                                      library, examine the library_error  

  --*< server exception, the broker returned an
  --                                      error, check replay  

   subtype amqp_response_type_enum is amqp_response_type_enum_u;  -- /usr/include/amqp.h:644

  --*
  -- * Reply from a RPC method on the broker
  -- *
  -- * \since v0.1
  --  

  --*< the reply type:
  --                                       * - AMQP_RESPONSE_NORMAL - the RPC
  --                                       * completed successfully
  --                                       * - AMQP_RESPONSE_SERVER_EXCEPTION - the
  --                                       * broker returned
  --                                       *     an exception, check the reply field
  --                                       * - AMQP_RESPONSE_LIBRARY_EXCEPTION - the
  --                                       * library
  --                                       *    encountered an error, check the
  --                                       * library_error field
  --                                        

   type amqp_rpc_reply_t_u is record
      reply_type : aliased amqp_response_type_enum;  -- /usr/include/amqp.h:652
      reply : aliased amqp_method_t;  -- /usr/include/amqp.h:663
      library_error : aliased int;  -- /usr/include/amqp.h:666
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp.h:651

  --*< in case of AMQP_RESPONSE_SERVER_EXCEPTION this
  --                        * field will be set to the method returned from the
  --                        * broker  

  --*< in case of AMQP_RESPONSE_LIBRARY_EXCEPTION this
  --                        *    field will be set to an error code. An error
  --                        *     string can be retrieved using amqp_error_string  

   subtype amqp_rpc_reply_t is amqp_rpc_reply_t_u;  -- /usr/include/amqp.h:669

  --*
  -- * SASL method type
  -- *
  -- * \since v0.1
  --  

   subtype amqp_sasl_method_enum_u is int;
   amqp_sasl_method_enum_u_AMQP_SASL_METHOD_UNDEFINED : constant amqp_sasl_method_enum_u := -1;
   amqp_sasl_method_enum_u_AMQP_SASL_METHOD_PLAIN : constant amqp_sasl_method_enum_u := 0;
   amqp_sasl_method_enum_u_AMQP_SASL_METHOD_EXTERNAL : constant amqp_sasl_method_enum_u := 1;  -- /usr/include/amqp.h:676

  --*< Invalid SASL method  
  --*< the PLAIN SASL method for authentication to the broker  
  --*< the EXTERNAL SASL method for authentication to the broker  
   subtype amqp_sasl_method_enum is amqp_sasl_method_enum_u;  -- /usr/include/amqp.h:682

  --*
  -- * connection state object
  -- *
  -- * \since v0.1
  --  

   type amqp_connection_state_t_u is null record;   -- incomplete struct

   type amqp_connection_state_t is access all amqp_connection_state_t_u;  -- /usr/include/amqp.h:689

  --*
  -- * Socket object
  -- *
  -- * \since v0.4.0
  --  

   type amqp_socket_t_u is null record;   -- incomplete struct

   subtype amqp_socket_t is amqp_socket_t_u;  -- /usr/include/amqp.h:696

  --*
  -- * Status codes
  -- *
  -- * \since v0.4.0
  --  

  -- NOTE: When updating this enum, update the strings in librabbitmq/amqp_api.c
  --  

   subtype amqp_status_enum_u is int;
   amqp_status_enum_u_AMQP_STATUS_OK : constant amqp_status_enum_u := 0;
   amqp_status_enum_u_AMQP_STATUS_NO_MEMORY : constant amqp_status_enum_u := -1;
   amqp_status_enum_u_AMQP_STATUS_BAD_AMQP_DATA : constant amqp_status_enum_u := -2;
   amqp_status_enum_u_AMQP_STATUS_UNKNOWN_CLASS : constant amqp_status_enum_u := -3;
   amqp_status_enum_u_AMQP_STATUS_UNKNOWN_METHOD : constant amqp_status_enum_u := -4;
   amqp_status_enum_u_AMQP_STATUS_HOSTNAME_RESOLUTION_FAILED : constant amqp_status_enum_u := -5;
   amqp_status_enum_u_AMQP_STATUS_INCOMPATIBLE_AMQP_VERSION : constant amqp_status_enum_u := -6;
   amqp_status_enum_u_AMQP_STATUS_CONNECTION_CLOSED : constant amqp_status_enum_u := -7;
   amqp_status_enum_u_AMQP_STATUS_BAD_URL : constant amqp_status_enum_u := -8;
   amqp_status_enum_u_AMQP_STATUS_SOCKET_ERROR : constant amqp_status_enum_u := -9;
   amqp_status_enum_u_AMQP_STATUS_INVALID_PARAMETER : constant amqp_status_enum_u := -10;
   amqp_status_enum_u_AMQP_STATUS_TABLE_TOO_BIG : constant amqp_status_enum_u := -11;
   amqp_status_enum_u_AMQP_STATUS_WRONG_METHOD : constant amqp_status_enum_u := -12;
   amqp_status_enum_u_AMQP_STATUS_TIMEOUT : constant amqp_status_enum_u := -13;
   amqp_status_enum_u_AMQP_STATUS_TIMER_FAILURE : constant amqp_status_enum_u := -14;
   amqp_status_enum_u_AMQP_STATUS_HEARTBEAT_TIMEOUT : constant amqp_status_enum_u := -15;
   amqp_status_enum_u_AMQP_STATUS_UNEXPECTED_STATE : constant amqp_status_enum_u := -16;
   amqp_status_enum_u_AMQP_STATUS_SOCKET_CLOSED : constant amqp_status_enum_u := -17;
   amqp_status_enum_u_AMQP_STATUS_SOCKET_INUSE : constant amqp_status_enum_u := -18;
   amqp_status_enum_u_AMQP_STATUS_BROKER_UNSUPPORTED_SASL_METHOD : constant amqp_status_enum_u := -19;
   amqp_status_enum_u_AMQP_STATUS_UNSUPPORTED : constant amqp_status_enum_u := -20;
   amqp_status_enum_u_u_AMQP_STATUS_NEXT_VALUE : constant amqp_status_enum_u := -21;
   amqp_status_enum_u_AMQP_STATUS_TCP_ERROR : constant amqp_status_enum_u := -256;
   amqp_status_enum_u_AMQP_STATUS_TCP_SOCKETLIB_INIT_ERROR : constant amqp_status_enum_u := -257;
   amqp_status_enum_u_u_AMQP_STATUS_TCP_NEXT_VALUE : constant amqp_status_enum_u := -258;
   amqp_status_enum_u_AMQP_STATUS_SSL_ERROR : constant amqp_status_enum_u := -512;
   amqp_status_enum_u_AMQP_STATUS_SSL_HOSTNAME_VERIFY_FAILED : constant amqp_status_enum_u := -513;
   amqp_status_enum_u_AMQP_STATUS_SSL_PEER_VERIFY_FAILED : constant amqp_status_enum_u := -514;
   amqp_status_enum_u_AMQP_STATUS_SSL_CONNECTION_FAILED : constant amqp_status_enum_u := -515;
   amqp_status_enum_u_AMQP_STATUS_SSL_SET_ENGINE_FAILED : constant amqp_status_enum_u := -516;
   amqp_status_enum_u_u_AMQP_STATUS_SSL_NEXT_VALUE : constant amqp_status_enum_u := -517;  -- /usr/include/amqp.h:705

  --*< Operation successful  
  --*< Memory allocation
  --                                                         failed  

  --*< Incorrect or corrupt
  --                                                         data was received from
  --                                                         the broker. This is a
  --                                                         protocol error.  

  --*< An unknown AMQP class
  --                                                         was received. This is
  --                                                         a protocol error.  

  --*< An unknown AMQP method
  --                                                         was received. This is
  --                                                         a protocol error.  

  --*< Unable to resolve the
  --                                                     * hostname  

  --*< The broker advertised
  --                                                         an incompaible AMQP
  --                                                         version  

  --*< The connection to the
  --                                                         broker has been closed
  --                                                          

  --*< malformed AMQP URL  
  --*< A socket error
  --                                                         occurred  

  --*< An invalid parameter
  --                                                         was passed into the
  --                                                         function  

  --*< The amqp_table_t object
  --                                                         cannot be serialized
  --                                                         because the output
  --                                                         buffer is too small  

  --*< The wrong method was
  --                                                         received  

  --*< Operation timed out  
  --*< The underlying system
  --                                                         timer facility failed  

  --*< Timed out waiting for
  --                                                         heartbeat  

  --*< Unexpected protocol
  --                                                         state  

  --*< Underlying socket is
  --                                                         closed  

  --*< Underlying socket is
  --                                                         already open  

  --*< Broker does not
  --                                                          support the requested
  --                                                          SASL mechanism  

  --*< Parameter is unsupported
  --                                       in this version  

  --*< Internal value  
  --*< A generic TCP error
  --                                                       occurred  

  --*< An error occurred trying
  --                                                       to initialize the
  --                                                       socket library 

  --*< Internal value  
  --*< A generic SSL error
  --                                                         occurred.  

  --*< SSL validation of
  --                                                         hostname against
  --                                                         peer certificate
  --                                                         failed  

  --*< SSL validation of peer
  --                                                         certificate failed.  

  --*< SSL handshake failed.  
  --*< SSL setting engine failed  
  --*< Internal value  
   subtype amqp_status_enum is amqp_status_enum_u;  -- /usr/include/amqp.h:775

  --*
  -- * AMQP delivery modes.
  -- * Use these values for the #amqp_basic_properties_t::delivery_mode field.
  -- *
  -- * \since v0.5
  --  

  --*< Non-persistent message  
  --* \file  
   subtype amqp_delivery_mode_enum is unsigned;
   amqp_delivery_mode_enum_AMQP_DELIVERY_NONPERSISTENT : constant amqp_delivery_mode_enum := 1;
   amqp_delivery_mode_enum_AMQP_DELIVERY_PERSISTENT : constant amqp_delivery_mode_enum := 2;  -- /usr/include/amqp.h:786

  --*
  -- * Empty bytes structure
  -- *
  -- * \since v0.2
  --  

   amqp_empty_bytes : aliased constant amqp_bytes_t  -- /usr/include/amqp.h:799
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_empty_bytes";

  --*
  -- * Empty table structure
  -- *
  -- * \since v0.2
  --  

   amqp_empty_table : aliased constant amqp_table_t  -- /usr/include/amqp.h:806
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_empty_table";

  --*
  -- * Empty table array structure
  -- *
  -- * \since v0.2
  --  

   amqp_empty_array : aliased constant amqp_array_t  -- /usr/include/amqp.h:813
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_empty_array";

  -- Compatibility macros for the above, to avoid the need to update
  --   code written against earlier versions of librabbitmq.  

  --*
  -- * \def AMQP_EMPTY_BYTES
  -- *
  -- * Deprecated, use \ref amqp_empty_bytes instead
  -- *
  -- * \deprecated use \ref amqp_empty_bytes instead
  -- *
  -- * \since v0.1
  --  

  --*
  -- * \def AMQP_EMPTY_TABLE
  -- *
  -- * Deprecated, use \ref amqp_empty_table instead
  -- *
  -- * \deprecated use \ref amqp_empty_table instead
  -- *
  -- * \since v0.1
  --  

  --*
  -- * \def AMQP_EMPTY_ARRAY
  -- *
  -- * Deprecated, use \ref amqp_empty_array instead
  -- *
  -- * \deprecated use \ref amqp_empty_array instead
  -- *
  -- * \since v0.1
  --  

  --*
  -- * Initializes an amqp_pool_t memory allocation pool for use
  -- *
  -- * Readies an allocation pool for use. An amqp_pool_t
  -- * must be initialized before use
  -- *
  -- * \param [in] pool the amqp_pool_t structure to initialize.
  -- *              Calling this function on a pool a pool that has
  -- *              already been initialized will result in undefined
  -- *              behavior
  -- * \param [in] pagesize the unit size that the pool will allocate
  -- *              memory chunks in. Anything allocated against the pool
  -- *              with a requested size will be carved out of a block
  -- *              this size. Allocations larger than this will be
  -- *              allocated individually
  -- *
  -- * \sa recycle_amqp_pool(), empty_amqp_pool(), amqp_pool_alloc(),
  -- *     amqp_pool_alloc_bytes(), amqp_pool_t
  -- *
  -- * \since v0.1
  --  

   procedure init_amqp_pool (pool : access amqp_pool_t; pagesize : size_t)  -- /usr/include/amqp.h:873
   with Import => True, 
        Convention => C, 
        External_Name => "init_amqp_pool";

  --*
  -- * Recycles an amqp_pool_t memory allocation pool
  -- *
  -- * Recycles the space allocate by the pool
  -- *
  -- * This invalidates all allocations made against the pool before this call is
  -- * made, any use of any allocations made before recycle_amqp_pool() is called
  -- * will result in undefined behavior.
  -- *
  -- * Note: this may or may not release memory, to force memory to be released
  -- * call empty_amqp_pool().
  -- *
  -- * \param [in] pool the amqp_pool_t to recycle
  -- *
  -- * \sa recycle_amqp_pool(), empty_amqp_pool(), amqp_pool_alloc(),
  -- *      amqp_pool_alloc_bytes()
  -- *
  -- * \since v0.1
  -- *
  --  

   procedure recycle_amqp_pool (pool : access amqp_pool_t)  -- /usr/include/amqp.h:896
   with Import => True, 
        Convention => C, 
        External_Name => "recycle_amqp_pool";

  --*
  -- * Empties an amqp memory pool
  -- *
  -- * Releases all memory associated with an allocation pool
  -- *
  -- * \param [in] pool the amqp_pool_t to empty
  -- *
  -- * \since v0.1
  --  

   procedure empty_amqp_pool (pool : access amqp_pool_t)  -- /usr/include/amqp.h:908
   with Import => True, 
        Convention => C, 
        External_Name => "empty_amqp_pool";

  --*
  -- * Allocates a block of memory from an amqp_pool_t memory pool
  -- *
  -- * Memory will be aligned on a 8-byte boundary. If a 0-length allocation is
  -- * requested, a NULL pointer will be returned.
  -- *
  -- * \param [in] pool the allocation pool to allocate the memory from
  -- * \param [in] amount the size of the allocation in bytes.
  -- * \return a pointer to the memory block, or NULL if the allocation cannot
  -- *          be satisfied.
  -- *
  -- * \sa init_amqp_pool(), recycle_amqp_pool(), empty_amqp_pool(),
  -- *     amqp_pool_alloc_bytes()
  -- *
  -- * \since v0.1
  --  

   function amqp_pool_alloc (pool : access amqp_pool_t; amount : size_t) return System.Address  -- /usr/include/amqp.h:927
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_pool_alloc";

  --*
  -- * Allocates a block of memory from an amqp_pool_t to an amqp_bytes_t
  -- *
  -- * Memory will be aligned on a 8-byte boundary. If a 0-length allocation is
  -- * requested, output.bytes = NULL.
  -- *
  -- * \param [in] pool the allocation pool to allocate the memory from
  -- * \param [in] amount the size of the allocation in bytes
  -- * \param [in] output the location to store the pointer. On success
  -- *              output.bytes will be set to the beginning of the buffer
  -- *              output.len will be set to amount
  -- *              On error output.bytes will be set to NULL and output.len
  -- *              set to 0
  -- *
  -- * \sa init_amqp_pool(), recycle_amqp_pool(), empty_amqp_pool(),
  -- *     amqp_pool_alloc()
  -- *
  -- * \since v0.1
  --  

   procedure amqp_pool_alloc_bytes
     (pool : access amqp_pool_t;
      amount : size_t;
      output : access amqp_bytes_t)  -- /usr/include/amqp.h:949
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_pool_alloc_bytes";

  --*
  -- * Wraps a c string in an amqp_bytes_t
  -- *
  -- * Takes a string, calculates its length and creates an
  -- * amqp_bytes_t that points to it. The string is not duplicated.
  -- *
  -- * For a given input cstr, The amqp_bytes_t output.bytes is the
  -- * same as cstr, output.len is the length of the string not including
  -- * the \0 terminator
  -- *
  -- * This function uses strlen() internally so cstr must be properly
  -- * terminated
  -- *
  -- * \param [in] cstr the c string to wrap
  -- * \return an amqp_bytes_t that describes the string
  -- *
  -- * \since v0.1
  --  

   function amqp_cstring_bytes (cstr : Interfaces.C.Strings.chars_ptr) return amqp_bytes_t  -- /usr/include/amqp.h:971
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_cstring_bytes";

  --*
  -- * Duplicates an amqp_bytes_t buffer.
  -- *
  -- * The buffer is cloned and the contents copied.
  -- *
  -- * The memory associated with the output is allocated
  -- * with amqp_bytes_malloc() and should be freed with
  -- * amqp_bytes_free()
  -- *
  -- * \param [in] src
  -- * \return a clone of the src
  -- *
  -- * \sa amqp_bytes_free(), amqp_bytes_malloc()
  -- *
  -- * \since v0.1
  --  

   function amqp_bytes_malloc_dup (src : amqp_bytes_t) return amqp_bytes_t  -- /usr/include/amqp.h:990
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_bytes_malloc_dup";

  --*
  -- * Allocates a amqp_bytes_t buffer
  -- *
  -- * Creates an amqp_bytes_t buffer of the specified amount, the buffer should be
  -- * freed using amqp_bytes_free()
  -- *
  -- * \param [in] amount the size of the buffer in bytes
  -- * \returns an amqp_bytes_t with amount bytes allocated.
  -- *           output.bytes will be set to NULL on error
  -- *
  -- * \sa amqp_bytes_free(), amqp_bytes_malloc_dup()
  -- *
  -- * \since v0.1
  --  

   function amqp_bytes_malloc (amount : size_t) return amqp_bytes_t  -- /usr/include/amqp.h:1007
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_bytes_malloc";

  --*
  -- * Frees an amqp_bytes_t buffer
  -- *
  -- * Frees a buffer allocated with amqp_bytes_malloc() or amqp_bytes_malloc_dup()
  -- *
  -- * Calling amqp_bytes_free on buffers not allocated with one
  -- * of those two functions will result in undefined behavior
  -- *
  -- * \param [in] bytes the buffer to free
  -- *
  -- * \sa amqp_bytes_malloc(), amqp_bytes_malloc_dup()
  -- *
  -- * \since v0.1
  --  

   procedure amqp_bytes_free (bytes : amqp_bytes_t)  -- /usr/include/amqp.h:1024
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_bytes_free";

  --*
  -- * Allocate and initialize a new amqp_connection_state_t object
  -- *
  -- * amqp_connection_state_t objects created with this function
  -- * should be freed with amqp_destroy_connection()
  -- *
  -- * \returns an opaque pointer on success, NULL or 0 on failure.
  -- *
  -- * \sa amqp_destroy_connection()
  -- *
  -- * \since v0.1
  --  

   function amqp_new_connection return amqp_connection_state_t  -- /usr/include/amqp.h:1039
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_new_connection";

  --*
  -- * Get the underlying socket descriptor for the connection
  -- *
  -- * \warning Use the socket returned from this function carefully, incorrect use
  -- * of the socket outside of the library will lead to undefined behavior.
  -- * Additionally rabbitmq-c may use the socket differently version-to-version,
  -- * what may work in one version, may break in the next version. Be sure to
  -- * thoroughly test any applications that use the socket returned by this
  -- * function especially when using a newer version of rabbitmq-c
  -- *
  -- * \param [in] state the connection object
  -- * \returns the socket descriptor if one has been set, -1 otherwise
  -- *
  -- * \sa amqp_tcp_socket_new(), amqp_ssl_socket_new(), amqp_socket_open()
  -- *
  -- * \since v0.1
  --  

   function amqp_get_sockfd (state : amqp_connection_state_t) return int  -- /usr/include/amqp.h:1059
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_get_sockfd";

  --*
  -- * Deprecated, use amqp_tcp_socket_new() or amqp_ssl_socket_new()
  -- *
  -- * \deprecated Use amqp_tcp_socket_new() or amqp_ssl_socket_new()
  -- *
  -- * Sets the socket descriptor associated with the connection. The socket
  -- * should be connected to a broker, and should not be read to or written from
  -- * before calling this function.  A socket descriptor can be created and opened
  -- * using amqp_open_socket()
  -- *
  -- * \param [in] state the connection object
  -- * \param [in] sockfd the socket
  -- *
  -- * \sa amqp_open_socket(), amqp_tcp_socket_new(), amqp_ssl_socket_new()
  -- *
  -- * \since v0.1
  --  

   procedure amqp_set_sockfd (state : amqp_connection_state_t; sockfd : int)  -- /usr/include/amqp.h:1078
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_set_sockfd";

  --*
  -- * Tune client side parameters
  -- *
  -- * \warning This function may call abort() if the connection is in a certain
  -- *  state. As such it should probably not be called code outside the library.
  -- *  connection parameters should be specified when calling amqp_login() or
  -- *  amqp_login_with_properties()
  -- *
  -- * This function changes channel_max, frame_max, and heartbeat parameters, on
  -- * the client side only. It does not try to renegotiate these parameters with
  -- * the broker. Using this function will lead to unexpected results.
  -- *
  -- * \param [in] state the connection object
  -- * \param [in] channel_max the maximum number of channels.
  -- *              The largest this can be is 65535
  -- * \param [in] frame_max the maximum size of an frame.
  -- *              The smallest this can be is 4096
  -- *              The largest this can be is 2147483647
  -- *              Unless you know what you're doing the recommended
  -- *              size is 131072 or 128KB
  -- * \param [in] heartbeat the number of seconds between heartbeats
  -- *
  -- * \return AMQP_STATUS_OK on success, an amqp_status_enum value otherwise.
  -- *  Possible error codes include:
  -- *  - AMQP_STATUS_NO_MEMORY memory allocation failed.
  -- *  - AMQP_STATUS_TIMER_FAILURE the underlying system timer indicated it
  -- *    failed.
  -- *
  -- * \sa amqp_login(), amqp_login_with_properties()
  -- *
  -- * \since v0.1
  --  

   function amqp_tune_connection
     (state : amqp_connection_state_t;
      channel_max : int;
      frame_max : int;
      heartbeat : int) return int  -- /usr/include/amqp.h:1114
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_tune_connection";

  --*
  -- * Get the maximum number of channels the connection can handle
  -- *
  -- * The maximum number of channels is set when connection negotiation takes
  -- * place in amqp_login() or amqp_login_with_properties().
  -- *
  -- * \param [in] state the connection object
  -- * \return the maximum number of channels. 0 if there is no limit
  -- *
  -- * \since v0.1
  --  

   function amqp_get_channel_max (state : amqp_connection_state_t) return int  -- /usr/include/amqp.h:1130
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_get_channel_max";

  --*
  -- * Get the maximum size of an frame the connection can handle
  -- *
  -- * The maximum size of an frame is set when connection negotiation takes
  -- * place in amqp_login() or amqp_login_with_properties().
  -- *
  -- * \param [in] state the connection object
  -- * \return the maximum size of an frame.
  -- *
  -- * \since v0.6
  --  

   function amqp_get_frame_max (state : amqp_connection_state_t) return int  -- /usr/include/amqp.h:1144
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_get_frame_max";

  --*
  -- * Get the number of seconds between heartbeats of the connection
  -- *
  -- * The number of seconds between heartbeats is set when connection
  -- * negotiation takes place in amqp_login() or amqp_login_with_properties().
  -- *
  -- * \param [in] state the connection object
  -- * \return the number of seconds between heartbeats.
  -- *
  -- * \since v0.6
  --  

   function amqp_get_heartbeat (state : amqp_connection_state_t) return int  -- /usr/include/amqp.h:1158
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_get_heartbeat";

  --*
  -- * Destroys an amqp_connection_state_t object
  -- *
  -- * Destroys a amqp_connection_state_t object that was created with
  -- * amqp_new_connection(). If the connection with the broker is open, it will be
  -- * implicitly closed with a reply code of 200 (success). Any memory that
  -- * would be freed with amqp_maybe_release_buffers() or
  -- * amqp_maybe_release_buffers_on_channel() will be freed, and use of that
  -- * memory will caused undefined behavior.
  -- *
  -- * \param [in] state the connection object
  -- * \return AMQP_STATUS_OK on success. amqp_status_enum value failure
  -- *
  -- * \sa amqp_new_connection()
  -- *
  -- * \since v0.1
  --  

   function amqp_destroy_connection (state : amqp_connection_state_t) return int  -- /usr/include/amqp.h:1178
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_destroy_connection";

  --*
  -- * Process incoming data
  -- *
  -- * \warning This is a low-level function intended for those who want to
  -- *  have greater control over input and output over the socket from the
  -- *  broker. Correctly using this function requires in-depth knowledge of AMQP
  -- *  and rabbitmq-c.
  -- *
  -- * For a given buffer of data received from the broker, decode the first
  -- * frame in the buffer. If more than one frame is contained in the input buffer
  -- * the return value will be less than the received_data size, the caller should
  -- * adjust received_data buffer descriptor to point to the beginning of the
  -- * buffer + the return value.
  -- *
  -- * \param [in] state the connection object
  -- * \param [in] received_data a buffer of data received from the broker. The
  -- *  function will return the number of bytes of the buffer it used. The
  -- *  function copies these bytes to an internal buffer: this part of the buffer
  -- *  may be reused after this function successfully completes.
  -- * \param [in,out] decoded_frame caller should pass in a pointer to an
  -- *  amqp_frame_t struct. If there is enough data in received_data for a
  -- *  complete frame, decoded_frame->frame_type will be set to something OTHER
  -- *  than 0. decoded_frame may contain members pointing to memory owned by
  -- *  the state object. This memory can be recycled with
  -- *  amqp_maybe_release_buffers() or amqp_maybe_release_buffers_on_channel().
  -- * \return number of bytes consumed from received_data or 0 if a 0-length
  -- *  buffer was passed. A negative return value indicates failure. Possible
  -- * errors:
  -- *  - AMQP_STATUS_NO_MEMORY failure in allocating memory. The library is likely
  -- *    in an indeterminate state making recovery unlikely. Client should note the
  -- *    error and terminate the application
  -- *  - AMQP_STATUS_BAD_AMQP_DATA bad AMQP data was received. The connection
  -- *    should be shutdown immediately
  -- *  - AMQP_STATUS_UNKNOWN_METHOD: an unknown method was received from the
  -- *    broker. This is likely a protocol error and the connection should be
  -- *    shutdown immediately
  -- *  - AMQP_STATUS_UNKNOWN_CLASS: a properties frame with an unknown class
  -- *    was received from the broker. This is likely a protocol error and the
  -- *    connection should be shutdown immediately
  -- *
  -- * \since v0.1
  --  

   function amqp_handle_input
     (state : amqp_connection_state_t;
      received_data : amqp_bytes_t;
      decoded_frame : access amqp_frame_t) return int  -- /usr/include/amqp.h:1223
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_handle_input";

  --*
  -- * Check to see if connection memory can be released
  -- *
  -- * \deprecated This function is deprecated in favor of
  -- *  amqp_maybe_release_buffers() or amqp_maybe_release_buffers_on_channel()
  -- *
  -- * Checks the state of an amqp_connection_state_t object to see if
  -- * amqp_release_buffers() can be called successfully.
  -- *
  -- * \param [in] state the connection object
  -- * \returns TRUE if the buffers can be released FALSE otherwise
  -- *
  -- * \sa amqp_release_buffers() amqp_maybe_release_buffers()
  -- *  amqp_maybe_release_buffers_on_channel()
  -- *
  -- * \since v0.1
  --  

   function amqp_release_buffers_ok (state : amqp_connection_state_t) return amqp_boolean_t  -- /usr/include/amqp.h:1245
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_release_buffers_ok";

  --*
  -- * Release amqp_connection_state_t owned memory
  -- *
  -- * \deprecated This function is deprecated in favor of
  -- *  amqp_maybe_release_buffers() or amqp_maybe_release_buffers_on_channel()
  -- *
  -- * \warning caller should ensure amqp_release_buffers_ok() returns true before
  -- *  calling this function. Failure to do so may result in abort() being called.
  -- *
  -- * Release memory owned by the amqp_connection_state_t for reuse by the
  -- * library. Use of any memory returned by the library before this function is
  -- * called will result in undefined behavior.
  -- *
  -- * \note internally rabbitmq-c tries to reuse memory when possible. As a result
  -- * its possible calling this function may not have a noticeable effect on
  -- * memory usage.
  -- *
  -- * \param [in] state the connection object
  -- *
  -- * \sa amqp_release_buffers_ok() amqp_maybe_release_buffers()
  -- *  amqp_maybe_release_buffers_on_channel()
  -- *
  -- * \since v0.1
  --  

   procedure amqp_release_buffers (state : amqp_connection_state_t)  -- /usr/include/amqp.h:1272
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_release_buffers";

  --*
  -- * Release amqp_connection_state_t owned memory
  -- *
  -- * Release memory owned by the amqp_connection_state_t object related to any
  -- * channel, allowing reuse by the library. Use of any memory returned by the
  -- * library before this function is called with result in undefined behavior.
  -- *
  -- * \note internally rabbitmq-c tries to reuse memory when possible. As a result
  -- * its possible calling this function may not have a noticeable effect on
  -- * memory usage.
  -- *
  -- * \param [in] state the connection object
  -- *
  -- * \sa amqp_maybe_release_buffers_on_channel()
  -- *
  -- * \since v0.1
  --  

   procedure amqp_maybe_release_buffers (state : amqp_connection_state_t)  -- /usr/include/amqp.h:1292
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_maybe_release_buffers";

  --*
  -- * Release amqp_connection_state_t owned memory related to a channel
  -- *
  -- * Release memory owned by the amqp_connection_state_t object related to the
  -- * specified channel, allowing reuse by the library. Use of any memory returned
  -- * the library for a specific channel will result in undefined behavior.
  -- *
  -- * \note internally rabbitmq-c tries to reuse memory when possible. As a result
  -- * its possible calling this function may not have a noticeable effect on
  -- * memory usage.
  -- *
  -- * \param [in] state the connection object
  -- * \param [in] channel the channel specifier for which memory should be
  -- *  released. Note that the library does not care about the state of the
  -- *  channel when calling this function
  -- *
  -- * \sa amqp_maybe_release_buffers()
  -- *
  -- * \since v0.4.0
  --  

   procedure amqp_maybe_release_buffers_on_channel (state : amqp_connection_state_t; channel : amqp_channel_t)  -- /usr/include/amqp.h:1315
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_maybe_release_buffers_on_channel";

  --*
  -- * Send a frame to the broker
  -- *
  -- * \param [in] state the connection object
  -- * \param [in] frame the frame to send to the broker
  -- * \return AMQP_STATUS_OK on success, an amqp_status_enum value on error.
  -- *  Possible error codes:
  -- *  - AMQP_STATUS_BAD_AMQP_DATA the serialized form of the method or
  -- *    properties was too large to fit in a single AMQP frame, or the
  -- *    method contains an invalid value. The frame was not sent.
  -- *  - AMQP_STATUS_TABLE_TOO_BIG the serialized form of an amqp_table_t is
  -- *    too large to fit in a single AMQP frame. Frame was not sent.
  -- *  - AMQP_STATUS_UNKNOWN_METHOD an invalid method type was passed in
  -- *  - AMQP_STATUS_UNKNOWN_CLASS an invalid properties type was passed in
  -- *  - AMQP_STATUS_TIMER_FAILURE system timer indicated failure. The frame
  -- *    was sent
  -- *  - AMQP_STATUS_SOCKET_ERROR
  -- *  - AMQP_STATUS_SSL_ERROR
  -- *
  -- * \since v0.1
  --  

   function amqp_send_frame (state : amqp_connection_state_t; frame : access constant amqp_frame_t) return int  -- /usr/include/amqp.h:1340
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_send_frame";

  --*
  -- * Compare two table entries
  -- *
  -- * Works just like strcmp(), comparing two the table keys, datatype, then values
  -- *
  -- * \param [in] entry1 the entry on the left
  -- * \param [in] entry2 the entry on the right
  -- * \return 0 if entries are equal, 0 < if left is greater, 0 > if right is
  -- * greater
  -- *
  -- * \since v0.1
  --  

   function amqp_table_entry_cmp (entry1 : System.Address; entry2 : System.Address) return int  -- /usr/include/amqp.h:1356
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_table_entry_cmp";

  --*
  -- * Open a socket to a remote host
  -- *
  -- * \deprecated This function is deprecated in favor of amqp_socket_open()
  -- *
  -- * Looks up the hostname, then attempts to open a socket to the host using
  -- * the specified portnumber. It also sets various options on the socket to
  -- * improve performance and correctness.
  -- *
  -- * \param [in] hostname this can be a hostname or IP address.
  -- *              Both IPv4 and IPv6 are acceptable
  -- * \param [in] portnumber the port to connect on. RabbitMQ brokers
  -- *              listen on port 5672, and 5671 for SSL
  -- * \return a positive value indicates success and is the sockfd. A negative
  -- *  value (see amqp_status_enum)is returned on failure. Possible error codes:
  -- *  - AMQP_STATUS_TCP_SOCKETLIB_INIT_ERROR Initialization of underlying socket
  -- *    library failed.
  -- *  - AMQP_STATUS_HOSTNAME_RESOLUTION_FAILED hostname lookup failed.
  -- *  - AMQP_STATUS_SOCKET_ERROR a socket error occurred. errno or
  -- *    WSAGetLastError() may return more useful information.
  -- *
  -- * \note IPv6 support was added in v0.3
  -- *
  -- * \sa amqp_socket_open() amqp_set_sockfd()
  -- *
  -- * \since v0.1
  --  

   function amqp_open_socket (hostname : Interfaces.C.Strings.chars_ptr; portnumber : int) return int  -- /usr/include/amqp.h:1386
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_open_socket";

  --*
  -- * Send initial AMQP header to the broker
  -- *
  -- * \warning this is a low level function intended for those who want to
  -- * interact with the broker at a very low level. Use of this function without
  -- * understanding what it does will result in AMQP protocol errors.
  -- *
  -- * This function sends the AMQP protocol header to the broker.
  -- *
  -- * \param [in] state the connection object
  -- * \return AMQP_STATUS_OK on success, a negative value on failure. Possible
  -- *  error codes:
  -- * - AMQP_STATUS_CONNECTION_CLOSED the connection to the broker was closed.
  -- * - AMQP_STATUS_SOCKET_ERROR a socket error occurred. It is likely the
  -- *   underlying socket has been closed. errno or WSAGetLastError() may provide
  -- *   further information.
  -- * - AMQP_STATUS_SSL_ERROR a SSL error occurred. The connection to the broker
  -- *   was closed.
  -- *
  -- * \since v0.1
  --  

   function amqp_send_header (state : amqp_connection_state_t) return int  -- /usr/include/amqp.h:1410
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_send_header";

  --*
  -- * Checks to see if there are any incoming frames ready to be read
  -- *
  -- * Checks to see if there are any amqp_frame_t objects buffered by the
  -- * amqp_connection_state_t object. Having one or more frames buffered means
  -- * that amqp_simple_wait_frame() or amqp_simple_wait_frame_noblock() will
  -- * return a frame without potentially blocking on a read() call.
  -- *
  -- * \param [in] state the connection object
  -- * \return TRUE if there are frames enqueued, FALSE otherwise
  -- *
  -- * \sa amqp_simple_wait_frame() amqp_simple_wait_frame_noblock()
  -- *  amqp_data_in_buffer()
  -- *
  -- * \since v0.1
  --  

   function amqp_frames_enqueued (state : amqp_connection_state_t) return amqp_boolean_t  -- /usr/include/amqp.h:1429
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_frames_enqueued";

  --*
  -- * Read a single amqp_frame_t
  -- *
  -- * Waits for the next amqp_frame_t frame to be read from the broker.
  -- * This function has the potential to block for a long time in the case of
  -- * waiting for a basic.deliver method frame from the broker.
  -- *
  -- * The library may buffer frames. When an amqp_connection_state_t object
  -- * has frames buffered calling amqp_simple_wait_frame() will return an
  -- * amqp_frame_t without entering a blocking read(). You can test to see if
  -- * an amqp_connection_state_t object has frames buffered by calling the
  -- * amqp_frames_enqueued() function.
  -- *
  -- * The library has a socket read buffer. When there is data in an
  -- * amqp_connection_state_t read buffer, amqp_simple_wait_frame() may return an
  -- * amqp_frame_t without entering a blocking read(). You can test to see if an
  -- * amqp_connection_state_t object has data in its read buffer by calling the
  -- * amqp_data_in_buffer() function.
  -- *
  -- * \param [in] state the connection object
  -- * \param [out] decoded_frame the frame
  -- * \return AMQP_STATUS_OK on success, an amqp_status_enum value
  -- *  is returned otherwise. Possible errors include:
  -- *  - AMQP_STATUS_NO_MEMORY failure in allocating memory. The library is likely
  -- *    in an indeterminate state making recovery unlikely. Client should note the
  -- *    error and terminate the application
  -- *  - AMQP_STATUS_BAD_AMQP_DATA bad AMQP data was received. The connection
  -- *    should be shutdown immediately
  -- *  - AMQP_STATUS_UNKNOWN_METHOD: an unknown method was received from the
  -- *    broker. This is likely a protocol error and the connection should be
  -- *    shutdown immediately
  -- *  - AMQP_STATUS_UNKNOWN_CLASS: a properties frame with an unknown class
  -- *    was received from the broker. This is likely a protocol error and the
  -- *    connection should be shutdown immediately
  -- *  - AMQP_STATUS_HEARTBEAT_TIMEOUT timed out while waiting for heartbeat
  -- *    from the broker. The connection has been closed.
  -- *  - AMQP_STATUS_TIMER_FAILURE system timer indicated failure.
  -- *  - AMQP_STATUS_SOCKET_ERROR a socket error occurred. The connection has
  -- *    been closed
  -- *  - AMQP_STATUS_SSL_ERROR a SSL socket error occurred. The connection has
  -- *    been closed.
  -- *
  -- * \sa amqp_simple_wait_frame_noblock() amqp_frames_enqueued()
  -- *  amqp_data_in_buffer()
  -- *
  -- * \note as of v0.4.0 this function will no longer return heartbeat frames
  -- *  when enabled by specifying a non-zero heartbeat value in amqp_login().
  -- *  Heartbeating is handled internally by the library.
  -- *
  -- * \since v0.1
  --  

   function amqp_simple_wait_frame (state : amqp_connection_state_t; decoded_frame : access amqp_frame_t) return int  -- /usr/include/amqp.h:1483
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_simple_wait_frame";

  --*
  -- * Read a single amqp_frame_t with a timeout.
  -- *
  -- * Waits for the next amqp_frame_t frame to be read from the broker, up to
  -- * a timespan specified by tv. The function will return AMQP_STATUS_TIMEOUT
  -- * if the timeout is reached. The tv value is not modified by the function.
  -- *
  -- * If a 0 timeval is specified, the function behaves as if its non-blocking: it
  -- * will test to see if a frame can be read from the broker, and return
  -- * immediately.
  -- *
  -- * If NULL is passed in for tv, the function will behave like
  -- * amqp_simple_wait_frame() and block until a frame is received from the broker
  -- *
  -- * The library may buffer frames.  When an amqp_connection_state_t object
  -- * has frames buffered calling amqp_simple_wait_frame_noblock() will return an
  -- * amqp_frame_t without entering a blocking read(). You can test to see if an
  -- * amqp_connection_state_t object has frames buffered by calling the
  -- * amqp_frames_enqueued() function.
  -- *
  -- * The library has a socket read buffer. When there is data in an
  -- * amqp_connection_state_t read buffer, amqp_simple_wait_frame_noblock() may
  -- * return
  -- * an amqp_frame_t without entering a blocking read(). You can test to see if an
  -- * amqp_connection_state_t object has data in its read buffer by calling the
  -- * amqp_data_in_buffer() function.
  -- *
  -- * \note This function does not return heartbeat frames. When enabled,
  -- *  heartbeating is handled internally by the library.
  -- *
  -- * \param [in,out] state the connection object
  -- * \param [out] decoded_frame the frame
  -- * \param [in] tv the maximum time to wait for a frame to be read. Setting
  -- * tv->tv_sec = 0 and tv->tv_usec = 0 will do a non-blocking read. Specifying
  -- * NULL for tv will make the function block until a frame is read.
  -- * \return AMQP_STATUS_OK on success. An amqp_status_enum value is returned
  -- *  otherwise. Possible errors include:
  -- *  - AMQP_STATUS_TIMEOUT the timeout was reached while waiting for a frame
  -- *    from the broker.
  -- *  - AMQP_STATUS_INVALID_PARAMETER the tv parameter contains an invalid value.
  -- *  - AMQP_STATUS_NO_MEMORY failure in allocating memory. The library is likely
  -- *    in an indeterminate state making recovery unlikely. Client should note the
  -- *    error and terminate the application
  -- *  - AMQP_STATUS_BAD_AMQP_DATA bad AMQP data was received. The connection
  -- *    should be shutdown immediately
  -- *  - AMQP_STATUS_UNKNOWN_METHOD: an unknown method was received from the
  -- *    broker. This is likely a protocol error and the connection should be
  -- *    shutdown immediately
  -- *  - AMQP_STATUS_UNKNOWN_CLASS: a properties frame with an unknown class
  -- *    was received from the broker. This is likely a protocol error and the
  -- *    connection should be shutdown immediately
  -- *  - AMQP_STATUS_HEARTBEAT_TIMEOUT timed out while waiting for heartbeat
  -- *    from the broker. The connection has been closed.
  -- *  - AMQP_STATUS_TIMER_FAILURE system timer indicated failure.
  -- *  - AMQP_STATUS_SOCKET_ERROR a socket error occurred. The connection has
  -- *    been closed
  -- *  - AMQP_STATUS_SSL_ERROR a SSL socket error occurred. The connection has
  -- *    been closed.
  -- *
  -- * \sa amqp_simple_wait_frame() amqp_frames_enqueued() amqp_data_in_buffer()
  -- *
  -- * \since v0.4.0
  --  

   function amqp_simple_wait_frame_noblock
     (state : amqp_connection_state_t;
      decoded_frame : access amqp_frame_t;
      tv : access constant timeval) return int  -- /usr/include/amqp.h:1550
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_simple_wait_frame_noblock";

  --*
  -- * Waits for a specific method from the broker
  -- *
  -- * \warning You probably don't want to use this function. If this function
  -- *  doesn't receive exactly the frame requested it closes the whole connection.
  -- *
  -- * Waits for a single method on a channel from the broker.
  -- * If a frame is received that does not match expected_channel
  -- * or expected_method the program will abort
  -- *
  -- * \param [in] state the connection object
  -- * \param [in] expected_channel the channel that the method should be delivered
  -- *  on
  -- * \param [in] expected_method the method to wait for
  -- * \param [out] output the method
  -- * \returns AMQP_STATUS_OK on success. An amqp_status_enum value is returned
  -- *  otherwise. Possible errors include:
  -- *  - AMQP_STATUS_WRONG_METHOD a frame containing the wrong method, wrong frame
  -- *    type or wrong channel was received. The connection is closed.
  -- *  - AMQP_STATUS_NO_MEMORY failure in allocating memory. The library is likely
  -- *    in an indeterminate state making recovery unlikely. Client should note the
  -- *    error and terminate the application
  -- *  - AMQP_STATUS_BAD_AMQP_DATA bad AMQP data was received. The connection
  -- *    should be shutdown immediately
  -- *  - AMQP_STATUS_UNKNOWN_METHOD: an unknown method was received from the
  -- *    broker. This is likely a protocol error and the connection should be
  -- *    shutdown immediately
  -- *  - AMQP_STATUS_UNKNOWN_CLASS: a properties frame with an unknown class
  -- *    was received from the broker. This is likely a protocol error and the
  -- *    connection should be shutdown immediately
  -- *  - AMQP_STATUS_HEARTBEAT_TIMEOUT timed out while waiting for heartbeat
  -- *    from the broker. The connection has been closed.
  -- *  - AMQP_STATUS_TIMER_FAILURE system timer indicated failure.
  -- *  - AMQP_STATUS_SOCKET_ERROR a socket error occurred. The connection has
  -- *    been closed
  -- *  - AMQP_STATUS_SSL_ERROR a SSL socket error occurred. The connection has
  -- *    been closed.
  -- *
  -- * \since v0.1
  --  

   function amqp_simple_wait_method
     (state : amqp_connection_state_t;
      expected_channel : amqp_channel_t;
      expected_method : amqp_method_number_t;
      output : access amqp_method_t) return int  -- /usr/include/amqp.h:1596
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_simple_wait_method";

  --*
  -- * Sends a method to the broker
  -- *
  -- * This is a thin wrapper around amqp_send_frame(), providing a way to send
  -- * a method to the broker on a specified channel.
  -- *
  -- * \param [in] state the connection object
  -- * \param [in] channel the channel object
  -- * \param [in] id the method number
  -- * \param [in] decoded the method object
  -- * \returns AMQP_STATUS_OK on success, an amqp_status_enum value otherwise.
  -- *  Possible errors include:
  -- *  - AMQP_STATUS_BAD_AMQP_DATA the serialized form of the method or
  -- *    properties was too large to fit in a single AMQP frame, or the
  -- *    method contains an invalid value. The frame was not sent.
  -- *  - AMQP_STATUS_TABLE_TOO_BIG the serialized form of an amqp_table_t is
  -- *    too large to fit in a single AMQP frame. Frame was not sent.
  -- *  - AMQP_STATUS_UNKNOWN_METHOD an invalid method type was passed in
  -- *  - AMQP_STATUS_UNKNOWN_CLASS an invalid properties type was passed in
  -- *  - AMQP_STATUS_TIMER_FAILURE system timer indicated failure. The frame
  -- *    was sent
  -- *  - AMQP_STATUS_SOCKET_ERROR
  -- *  - AMQP_STATUS_SSL_ERROR
  -- *
  -- * \since v0.1
  --  

   function amqp_send_method
     (state : amqp_connection_state_t;
      channel : amqp_channel_t;
      id : amqp_method_number_t;
      decoded : System.Address) return int  -- /usr/include/amqp.h:1628
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_send_method";

  --*
  -- * Sends a method to the broker and waits for a method response
  -- *
  -- * \param [in] state the connection object
  -- * \param [in] channel the channel object
  -- * \param [in] request_id the method number of the request
  -- * \param [in] expected_reply_ids a 0 terminated array of expected response
  -- *             method numbers
  -- * \param [in] decoded_request_method the method to be sent to the broker
  -- * \return a amqp_rpc_reply_t:
  -- *  - r.reply_type == AMQP_RESPONSE_NORMAL. RPC completed successfully
  -- *  - r.reply_type == AMQP_RESPONSE_SERVER_EXCEPTION. The broker returned an
  -- *    exception:
  -- *    - If r.reply.id == AMQP_CHANNEL_CLOSE_METHOD a channel exception
  -- *      occurred, cast r.reply.decoded to amqp_channel_close_t* to see details
  -- *      of the exception. The client should amqp_send_method() a
  -- *      amqp_channel_close_ok_t. The channel must be re-opened before it
  -- *      can be used again. Any resources associated with the channel
  -- *      (auto-delete exchanges, auto-delete queues, consumers) are invalid
  -- *      and must be recreated before attempting to use them again.
  -- *    - If r.reply.id == AMQP_CONNECTION_CLOSE_METHOD a connection exception
  -- *      occurred, cast r.reply.decoded to amqp_connection_close_t* to see
  -- *      details of the exception. The client amqp_send_method() a
  -- *      amqp_connection_close_ok_t and disconnect from the broker.
  -- *  - r.reply_type == AMQP_RESPONSE_LIBRARY_EXCEPTION. An exception occurred
  -- *    within the library. Examine r.library_error and compare it against
  -- *    amqp_status_enum values to determine the error.
  -- *
  -- * \sa amqp_simple_rpc_decoded()
  -- *
  -- * \since v0.1
  --  

   function amqp_simple_rpc
     (state : amqp_connection_state_t;
      channel : amqp_channel_t;
      request_id : amqp_method_number_t;
      expected_reply_ids : access amqp_method_number_t;
      decoded_request_method : System.Address) return amqp_rpc_reply_t  -- /usr/include/amqp.h:1665
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_simple_rpc";

  --*
  -- * Sends a method to the broker and waits for a method response
  -- *
  -- * \param [in] state the connection object
  -- * \param [in] channel the channel object
  -- * \param [in] request_id the method number of the request
  -- * \param [in] reply_id the method number expected in response
  -- * \param [in] decoded_request_method the request method
  -- * \return a pointer to the method returned from the broker, or NULL on error.
  -- *  On error amqp_get_rpc_reply() will return an amqp_rpc_reply_t with
  -- *  details on the error that occurred.
  -- *
  -- * \since v0.1
  --  

   function amqp_simple_rpc_decoded
     (state : amqp_connection_state_t;
      channel : amqp_channel_t;
      request_id : amqp_method_number_t;
      reply_id : amqp_method_number_t;
      decoded_request_method : System.Address) return System.Address  -- /usr/include/amqp.h:1685
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_simple_rpc_decoded";

  --*
  -- * Get the last global amqp_rpc_reply
  -- *
  -- * The API methods corresponding to most synchronous AMQP methods
  -- * return a pointer to the decoded method result.  Upon error, they
  -- * return NULL, and we need some way of discovering what, if anything,
  -- * went wrong. amqp_get_rpc_reply() returns the most recent
  -- * amqp_rpc_reply_t instance corresponding to such an API operation
  -- * for the given connection.
  -- *
  -- * Only use it for operations that do not themselves return
  -- * amqp_rpc_reply_t; operations that do return amqp_rpc_reply_t
  -- * generally do NOT update this per-connection-global amqp_rpc_reply_t
  -- * instance.
  -- *
  -- * \param [in] state the connection object
  -- * \return the most recent amqp_rpc_reply_t:
  -- *  - r.reply_type == AMQP_RESPONSE_NORMAL. RPC completed successfully
  -- *  - r.reply_type == AMQP_RESPONSE_SERVER_EXCEPTION. The broker returned an
  -- *    exception:
  -- *    - If r.reply.id == AMQP_CHANNEL_CLOSE_METHOD a channel exception
  -- *      occurred, cast r.reply.decoded to amqp_channel_close_t* to see details
  -- *      of the exception. The client should amqp_send_method() a
  -- *      amqp_channel_close_ok_t. The channel must be re-opened before it
  -- *      can be used again. Any resources associated with the channel
  -- *      (auto-delete exchanges, auto-delete queues, consumers) are invalid
  -- *      and must be recreated before attempting to use them again.
  -- *    - If r.reply.id == AMQP_CONNECTION_CLOSE_METHOD a connection exception
  -- *      occurred, cast r.reply.decoded to amqp_connection_close_t* to see
  -- *      details of the exception. The client amqp_send_method() a
  -- *      amqp_connection_close_ok_t and disconnect from the broker.
  -- *  - r.reply_type == AMQP_RESPONSE_LIBRARY_EXCEPTION. An exception occurred
  -- *    within the library. Examine r.library_error and compare it against
  -- *    amqp_status_enum values to determine the error.
  -- *
  -- * \sa amqp_simple_rpc_decoded()
  -- *
  -- * \since v0.1
  --  

   function amqp_get_rpc_reply (state : amqp_connection_state_t) return amqp_rpc_reply_t  -- /usr/include/amqp.h:1731
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_get_rpc_reply";

  --*
  -- * Login to the broker
  -- *
  -- * After using amqp_open_socket and amqp_set_sockfd, call
  -- * amqp_login to complete connecting to the broker
  -- *
  -- * \param [in] state the connection object
  -- * \param [in] vhost the virtual host to connect to on the broker. The default
  -- *              on most brokers is "/"
  -- * \param [in] channel_max the limit for number of channels for the connection.
  -- *              0 means no limit, and is a good default
  -- *              (AMQP_DEFAULT_MAX_CHANNELS)
  -- *              Note that the maximum number of channels the protocol supports
  -- *              is 65535 (2^16, with the 0-channel reserved). The server can
  -- *              set a lower channel_max and then the client will use the lowest
  -- *              of the two
  -- * \param [in] frame_max the maximum size of an AMQP frame on the wire to
  -- *              request of the broker for this connection. 4096 is the minimum
  -- *              size, 2^31-1 is the maximum, a good default is 131072 (128KB),
  -- *              or AMQP_DEFAULT_FRAME_SIZE
  -- * \param [in] heartbeat the number of seconds between heartbeat frames to
  -- *              request of the broker. A value of 0 disables heartbeats.
  -- *              Note rabbitmq-c only has partial support for heartbeats, as of
  -- *              v0.4.0 they are only serviced during amqp_basic_publish() and
  -- *              amqp_simple_wait_frame()/amqp_simple_wait_frame_noblock()
  -- * \param [in] sasl_method the SASL method to authenticate with the broker.
  -- *              followed by the authentication information. The following SASL
  -- *              methods are implemented:
  -- *              -  AMQP_SASL_METHOD_PLAIN, the AMQP_SASL_METHOD_PLAIN argument
  -- *                 should be followed by two arguments in this order:
  -- *                 const char* username, and const char* password.
  -- *              -  AMQP_SASL_METHOD_EXTERNAL, the AMQP_SASL_METHOD_EXTERNAL
  -- *                 argument should be followed one argument:
  -- *                 const char* identity.
  -- * \return amqp_rpc_reply_t indicating success or failure.
  -- *  - r.reply_type == AMQP_RESPONSE_NORMAL. Login completed successfully
  -- *  - r.reply_type == AMQP_RESPONSE_LIBRARY_EXCEPTION. In most cases errors
  -- *    from the broker when logging in will be represented by the broker closing
  -- *    the socket. In this case r.library_error will be set to
  -- *    AMQP_STATUS_CONNECTION_CLOSED. This error can represent a number of
  -- *    error conditions including: invalid vhost, authentication failure.
  -- *  - r.reply_type == AMQP_RESPONSE_SERVER_EXCEPTION. The broker returned an
  -- *    exception:
  -- *    - If r.reply.id == AMQP_CHANNEL_CLOSE_METHOD a channel exception
  -- *      occurred, cast r.reply.decoded to amqp_channel_close_t* to see details
  -- *      of the exception. The client should amqp_send_method() a
  -- *      amqp_channel_close_ok_t. The channel must be re-opened before it
  -- *      can be used again. Any resources associated with the channel
  -- *      (auto-delete exchanges, auto-delete queues, consumers) are invalid
  -- *      and must be recreated before attempting to use them again.
  -- *    - If r.reply.id == AMQP_CONNECTION_CLOSE_METHOD a connection exception
  -- *      occurred, cast r.reply.decoded to amqp_connection_close_t* to see
  -- *      details of the exception. The client amqp_send_method() a
  -- *      amqp_connection_close_ok_t and disconnect from the broker.
  -- *
  -- * \since v0.1
  --  

   function amqp_login
     (state : amqp_connection_state_t;
      vhost : Interfaces.C.Strings.chars_ptr;
      channel_max : int;
      frame_max : int;
      heartbeat : int;
      sasl_method : amqp_sasl_method_enum  -- , ...
      ) return amqp_rpc_reply_t  -- /usr/include/amqp.h:1791
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_login";

  --*
  -- * Login to the broker passing a properties table
  -- *
  -- * This function is similar to amqp_login() and differs in that it provides a
  -- * way to pass client properties to the broker. This is commonly used to
  -- * negotiate newer protocol features as they are supported by the broker.
  -- *
  -- * \param [in] state the connection object
  -- * \param [in] vhost the virtual host to connect to on the broker. The default
  -- *              on most brokers is "/"
  -- * \param [in] channel_max the limit for the number of channels for the
  -- *             connection.
  -- *             0 means no limit, and is a good default
  -- *             (AMQP_DEFAULT_MAX_CHANNELS)
  -- *             Note that the maximum number of channels the protocol supports
  -- *             is 65535 (2^16, with the 0-channel reserved). The server can
  -- *             set a lower channel_max and then the client will use the lowest
  -- *             of the two
  -- * \param [in] frame_max the maximum size of an AMQP frame ont he wire to
  -- *              request of the broker for this connection. 4096 is the minimum
  -- *              size, 2^31-1 is the maximum, a good default is 131072 (128KB),
  -- *              or AMQP_DEFAULT_FRAME_SIZE
  -- * \param [in] heartbeat the number of seconds between heartbeat frame to
  -- *             request of the broker. A value of 0 disables heartbeats.
  -- *             Note rabbitmq-c only has partial support for hearts, as of
  -- *             v0.4.0 heartbeats are only serviced during amqp_basic_publish(),
  -- *             and amqp_simple_wait_frame()/amqp_simple_wait_frame_noblock()
  -- * \param [in] properties a table of properties to send the broker.
  -- * \param [in] sasl_method the SASL method to authenticate with the broker
  -- *             followed by the authentication information. The following SASL
  -- *             methods are implemented:
  -- *             -  AMQP_SASL_METHOD_PLAIN, the AMQP_SASL_METHOD_PLAIN argument
  -- *                should be followed by two arguments in this order:
  -- *                const char* username, and const char* password.
  -- *             -  AMQP_SASL_METHOD_EXTERNAL, the AMQP_SASL_METHOD_EXTERNAL
  -- *                argument should be followed one argument:
  -- *                const char* identity.
  -- * \return amqp_rpc_reply_t indicating success or failure.
  -- *  - r.reply_type == AMQP_RESPONSE_NORMAL. Login completed successfully
  -- *  - r.reply_type == AMQP_RESPONSE_LIBRARY_EXCEPTION. In most cases errors
  -- *    from the broker when logging in will be represented by the broker closing
  -- *    the socket. In this case r.library_error will be set to
  -- *    AMQP_STATUS_CONNECTION_CLOSED. This error can represent a number of
  -- *    error conditions including: invalid vhost, authentication failure.
  -- *  - r.reply_type == AMQP_RESPONSE_SERVER_EXCEPTION. The broker returned an
  -- *    exception:
  -- *    - If r.reply.id == AMQP_CHANNEL_CLOSE_METHOD a channel exception
  -- *      occurred, cast r.reply.decoded to amqp_channel_close_t* to see details
  -- *      of the exception. The client should amqp_send_method() a
  -- *      amqp_channel_close_ok_t. The channel must be re-opened before it
  -- *      can be used again. Any resources associated with the channel
  -- *      (auto-delete exchanges, auto-delete queues, consumers) are invalid
  -- *      and must be recreated before attempting to use them again.
  -- *    - If r.reply.id == AMQP_CONNECTION_CLOSE_METHOD a connection exception
  -- *      occurred, cast r.reply.decoded to amqp_connection_close_t* to see
  -- *      details of the exception. The client amqp_send_method() a
  -- *      amqp_connection_close_ok_t and disconnect from the broker.
  -- *
  -- * \since v0.4.0
  --  

   function amqp_login_with_properties
     (state : amqp_connection_state_t;
      vhost : Interfaces.C.Strings.chars_ptr;
      channel_max : int;
      frame_max : int;
      heartbeat : int;
      properties : access constant amqp_table_t;
      sasl_method : amqp_sasl_method_enum  -- , ...
      ) return amqp_rpc_reply_t  -- /usr/include/amqp.h:1857
   with Import => True,
        Convention => C,
        External_Name => "amqp_login_with_properties";

  --  Moved from amqp_framing.h to resolve circular dependency
  --* basic class properties
  --*< bit-mask of set fields
   type amqp_basic_properties_t_u is record
      u_flags : aliased amqp_flags_t;  -- /usr/include/amqp_framing.h:849
      content_type : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:850
      content_encoding : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:851
      headers : aliased amqp_table_t;  -- /usr/include/amqp_framing.h:852
      delivery_mode : aliased Unsigned_8;  -- /usr/include/amqp_framing.h:853
      priority : aliased Unsigned_8;  -- /usr/include/amqp_framing.h:854
      correlation_id : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:855
      reply_to : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:856
      expiration : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:857
      message_id : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:858
      timestamp : aliased Unsigned_64;  -- /usr/include/amqp_framing.h:859
      c_type : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:860
      user_id : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:861
      app_id : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:862
      cluster_id : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:863
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:848

   subtype amqp_basic_properties_t is amqp_basic_properties_t_u;  -- /usr/include/amqp_framing.h:864

  --*
  -- * Publish a message to the broker
  -- *
  -- * Publish a message on an exchange with a routing key.
  -- *
  -- * Note that at the AMQ protocol level basic.publish is an async method:
  -- * this means error conditions that occur on the broker (such as publishing to
  -- * a non-existent exchange) will not be reflected in the return value of this
  -- * function.
  -- *
  -- * \param [in] state the connection object
  -- * \param [in] channel the channel identifier
  -- * \param [in] exchange the exchange on the broker to publish to
  -- * \param [in] routing_key the routing key to use when publishing the message
  -- * \param [in] mandatory indicate to the broker that the message MUST be routed
  -- *              to a queue. If the broker cannot do this it should respond with
  -- *              a basic.return method.
  -- * \param [in] immediate indicate to the broker that the message MUST be
  -- *             delivered to a consumer immediately. If the broker cannot do this
  -- *             it should respond with a basic.return method.
  -- * \param [in] properties the properties associated with the message
  -- * \param [in] body the message body
  -- * \return AMQP_STATUS_OK on success, amqp_status_enum value on failure. Note
  -- *         that basic.publish is an async method, the return value from this
  -- *         function only indicates that the message data was successfully
  -- *         transmitted to the broker. It does not indicate failures that occur
  -- *         on the broker, such as publishing to a non-existent exchange.
  -- *         Possible error values:
  -- *         - AMQP_STATUS_TIMER_FAILURE: system timer facility returned an error
  -- *           the message was not sent.
  -- *         - AMQP_STATUS_HEARTBEAT_TIMEOUT: connection timed out waiting for a
  -- *           heartbeat from the broker. The message was not sent.
  -- *         - AMQP_STATUS_NO_MEMORY: memory allocation failed. The message was
  -- *           not sent.
  -- *         - AMQP_STATUS_TABLE_TOO_BIG: a table in the properties was too large
  -- *           to fit in a single frame. Message was not sent.
  -- *         - AMQP_STATUS_CONNECTION_CLOSED: the connection was closed.
  -- *         - AMQP_STATUS_SSL_ERROR: a SSL error occurred.
  -- *         - AMQP_STATUS_TCP_ERROR: a TCP error occurred. errno or
  -- *           WSAGetLastError() may provide more information
  -- *
  -- * Note: this function does heartbeat processing as of v0.4.0
  -- *
  -- * \since v0.1
  --  

   function amqp_basic_publish
     (state : amqp_connection_state_t;
      channel : amqp_channel_t;
      exchange : amqp_bytes_t;
      routing_key : amqp_bytes_t;
      mandatory : amqp_boolean_t;
      immediate : amqp_boolean_t;
      properties : access constant amqp_basic_properties_t_u;
      c_body : amqp_bytes_t) return int  -- /usr/include/amqp.h:1910
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_basic_publish";

  --*
  -- * Closes an channel
  -- *
  -- * \param [in] state the connection object
  -- * \param [in] channel the channel identifier
  -- * \param [in] code the reason for closing the channel, AMQP_REPLY_SUCCESS is a
  -- *             good default
  -- * \return amqp_rpc_reply_t indicating success or failure
  -- *
  -- * \since v0.1
  --  

   function amqp_channel_close
     (state : amqp_connection_state_t;
      channel : amqp_channel_t;
      code : int) return amqp_rpc_reply_t  -- /usr/include/amqp.h:1928
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_channel_close";

  --*
  -- * Closes the entire connection
  -- *
  -- * Implicitly closes all channels and informs the broker the connection
  -- * is being closed, after receiving acknowledgment from the broker it closes
  -- * the socket.
  -- *
  -- * \param [in] state the connection object
  -- * \param [in] code the reason code for closing the connection.
  -- *             AMQP_REPLY_SUCCESS is a good default.
  -- * \return amqp_rpc_reply_t indicating the result
  -- *
  -- * \since v0.1
  --  

   function amqp_connection_close (state : amqp_connection_state_t; code : int) return amqp_rpc_reply_t  -- /usr/include/amqp.h:1946
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_connection_close";

  --*
  -- * Acknowledges a message
  -- *
  -- * Does a basic.ack on a received message
  -- *
  -- * \param [in] state the connection object
  -- * \param [in] channel the channel identifier
  -- * \param [in] delivery_tag the delivery tag of the message to be ack'd
  -- * \param [in] multiple if true, ack all messages up to this delivery tag, if
  -- *              false ack only this delivery tag
  -- * \return 0 on success,  0 > on failing to send the ack to the broker.
  -- *            this will not indicate failure if something goes wrong on the
  -- *            broker
  -- *
  -- * \since v0.1
  --  

   function amqp_basic_ack
     (state : amqp_connection_state_t;
      channel : amqp_channel_t;
      delivery_tag : Unsigned_64;
      multiple : amqp_boolean_t) return int  -- /usr/include/amqp.h:1966
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_basic_ack";

  --*
  -- * Do a basic.get
  -- *
  -- * Synchonously polls the broker for a message in a queue, and
  -- * retrieves the message if a message is in the queue.
  -- *
  -- * \param [in] state the connection object
  -- * \param [in] channel the channel identifier to use
  -- * \param [in] queue the queue name to retrieve from
  -- * \param [in] no_ack if true the message is automatically ack'ed
  -- *              if false amqp_basic_ack should be called once the message
  -- *              retrieved has been processed
  -- * \return amqp_rpc_reply indicating success or failure
  -- *
  -- * \since v0.1
  --  

   function amqp_basic_get
     (state : amqp_connection_state_t;
      channel : amqp_channel_t;
      queue : amqp_bytes_t;
      no_ack : amqp_boolean_t) return amqp_rpc_reply_t  -- /usr/include/amqp.h:1987
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_basic_get";

  --*
  -- * Do a basic.reject
  -- *
  -- * Actively reject a message that has been delivered
  -- *
  -- * \param [in] state the connection object
  -- * \param [in] channel the channel identifier
  -- * \param [in] delivery_tag the delivery tag of the message to reject
  -- * \param [in] requeue indicate to the broker whether it should requeue the
  -- *              message or just discard it.
  -- * \return 0 on success, 0 > on failing to send the reject method to the broker.
  -- *          This will not indicate failure if something goes wrong on the
  -- * broker.
  -- *
  -- * \since v0.1
  --  

   function amqp_basic_reject
     (state : amqp_connection_state_t;
      channel : amqp_channel_t;
      delivery_tag : Unsigned_64;
      c_requeue : amqp_boolean_t) return int  -- /usr/include/amqp.h:2009
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_basic_reject";

  --*
  -- * Do a basic.nack
  -- *
  -- * Actively reject a message, this has the same effect as amqp_basic_reject()
  -- * however, amqp_basic_nack() can negatively acknowledge multiple messages with
  -- * one call much like amqp_basic_ack() can acknowledge mutliple messages with
  -- * one call.
  -- *
  -- * \param [in] state the connection object
  -- * \param [in] channel the channel identifier
  -- * \param [in] delivery_tag the delivery tag of the message to reject
  -- * \param [in] multiple if set to 1 negatively acknowledge all unacknowledged
  -- *              messages on this channel.
  -- * \param [in] requeue indicate to the broker whether it should requeue the
  -- *              message or dead-letter it.
  -- * \return AMQP_STATUS_OK on success, an amqp_status_enum value otherwise.
  -- *
  -- * \since v0.5.0
  --  

   function amqp_basic_nack
     (state : amqp_connection_state_t;
      channel : amqp_channel_t;
      delivery_tag : Unsigned_64;
      multiple : amqp_boolean_t;
      c_requeue : amqp_boolean_t) return int  -- /usr/include/amqp.h:2033
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_basic_nack";

  --*
  -- * Check to see if there is data left in the receive buffer
  -- *
  -- * Can be used to see if there is data still in the buffer, if so
  -- * calling amqp_simple_wait_frame will not immediately enter a
  -- * blocking read.
  -- *
  -- * \param [in] state the connection object
  -- * \return true if there is data in the recieve buffer, false otherwise
  -- *
  -- * \since v0.1
  --  

   function amqp_data_in_buffer (state : amqp_connection_state_t) return amqp_boolean_t  -- /usr/include/amqp.h:2049
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_data_in_buffer";

  --*
  -- * Get the error string for the given error code.
  -- *
  -- * \deprecated This function has been deprecated in favor of
  -- *  \ref amqp_error_string2() which returns statically allocated
  -- *  string which do not need to be freed by the caller.
  -- *
  -- * The returned string resides on the heap; the caller is responsible
  -- * for freeing it.
  -- *
  -- * \param [in] err return error code
  -- * \return the error string
  -- *
  -- * \since v0.1
  --  

   function amqp_error_string (err : int) return Interfaces.C.Strings.chars_ptr  -- /usr/include/amqp.h:2066
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_error_string";

  --*
  -- * Get the error string for the given error code.
  -- *
  -- * Get an error string associated with an error code. The string is statically
  -- * allocated and does not need to be freed
  -- *
  -- * \param [in] err the error code
  -- * \return the error string
  -- *
  -- * \since v0.4.0
  --  

   function amqp_error_string2 (err : int) return Interfaces.C.Strings.chars_ptr  -- /usr/include/amqp.h:2081
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_error_string2";

  --*
  -- * Deserialize an amqp_table_t from AMQP wireformat
  -- *
  -- * This is an internal function and is not typically used by
  -- * client applications
  -- *
  -- * \param [in] encoded the buffer containing the serialized data
  -- * \param [in] pool memory pool used to allocate the table entries from
  -- * \param [in] output the amqp_table_t structure to fill in. Any existing
  -- *             entries will be erased
  -- * \param [in,out] offset The offset into the encoded buffer to start
  -- *                 reading the serialized table. It will be updated
  -- *                 by this function to end of the table
  -- * \return AMQP_STATUS_OK on success, an amqp_status_enum value on failure
  -- *  Possible error codes:
  -- *  - AMQP_STATUS_NO_MEMORY out of memory
  -- *  - AMQP_STATUS_BAD_AMQP_DATA invalid wireformat
  -- *
  -- * \since v0.1
  --  

   function amqp_decode_table
     (encoded : amqp_bytes_t;
      pool : access amqp_pool_t;
      output : access amqp_table_t;
      offset : access size_t) return int  -- /usr/include/amqp.h:2104
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_decode_table";

  --*
  -- * Serializes an amqp_table_t to the AMQP wireformat
  -- *
  -- * This is an internal function and is not typically used by
  -- * client applications
  -- *
  -- * \param [in] encoded the buffer where to serialize the table to
  -- * \param [in] input the amqp_table_t to serialize
  -- * \param [in,out] offset The offset into the encoded buffer to start
  -- *                 writing the serialized table. It will be updated
  -- *                 by this function to where writing left off
  -- * \return AMQP_STATUS_OK on success, an amqp_status_enum value on failure
  -- *  Possible error codes:
  -- *  - AMQP_STATUS_TABLE_TOO_BIG the serialized form is too large for the
  -- *    buffer
  -- *  - AMQP_STATUS_BAD_AMQP_DATA invalid table
  -- *
  -- * \since v0.1
  --  

   function amqp_encode_table
     (encoded : amqp_bytes_t;
      input : access amqp_table_t;
      offset : access size_t) return int  -- /usr/include/amqp.h:2127
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_encode_table";

  --*
  -- * Create a deep-copy of an amqp_table_t object
  -- *
  -- * Creates a deep-copy of an amqp_table_t object, using the provided pool
  -- * object to allocate the necessary memory. This memory can be freed later by
  -- * call recycle_amqp_pool(), or empty_amqp_pool()
  -- *
  -- * \param [in] original the table to copy
  -- * \param [in,out] clone the table to copy to
  -- * \param [in] pool the initialized memory pool to do allocations for the table
  -- *             from
  -- * \return AMQP_STATUS_OK on success, amqp_status_enum value on failure.
  -- *  Possible error values:
  -- *  - AMQP_STATUS_NO_MEMORY - memory allocation failure.
  -- *  - AMQP_STATUS_INVALID_PARAMETER - invalid table (e.g., no key name)
  -- *
  -- * \since v0.4.0
  --  

   function amqp_table_clone
     (original : access constant amqp_table_t;
      clone : access amqp_table_t;
      pool : access amqp_pool_t) return int  -- /usr/include/amqp.h:2149
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_table_clone";

  --*
  -- * A message object
  -- *
  -- * \since v0.4.0
  --

  --*< message properties
   type amqp_message_t_u is record
      properties : aliased amqp_basic_properties_t;  -- /usr/include/amqp.h:2158
      c_body : aliased amqp_bytes_t;  -- /usr/include/amqp.h:2159
      pool : aliased amqp_pool_t;  -- /usr/include/amqp.h:2160
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp.h:2157

  --*< message body  
  --*< pool used to allocate properties  
   subtype amqp_message_t is amqp_message_t_u;  -- /usr/include/amqp.h:2161

  --*
  -- * Reads the next message on a channel
  -- *
  -- * Reads a complete message (header + body) on a specified channel. This
  -- * function is intended to be used with amqp_basic_get() or when an
  -- * AMQP_BASIC_DELIVERY_METHOD method is received.
  -- *
  -- * \param [in,out] state the connection object
  -- * \param [in] channel the channel on which to read the message from
  -- * \param [in,out] message a pointer to a amqp_message_t object. Caller should
  -- *                 call amqp_message_destroy() when it is done using the
  -- *                 fields in the message object.  The caller is responsible for
  -- *                 allocating/destroying the amqp_message_t object itself.
  -- * \param [in] flags pass in 0. Currently unused.
  -- * \returns a amqp_rpc_reply_t object. ret.reply_type == AMQP_RESPONSE_NORMAL on
  -- * success.
  -- *
  -- * \since v0.4.0
  --  

   function amqp_read_message
     (state : amqp_connection_state_t;
      channel : amqp_channel_t;
      message : access amqp_message_t;
      flags : int) return amqp_rpc_reply_t  -- /usr/include/amqp.h:2183
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_read_message";

  --*
  -- * Frees memory associated with a amqp_message_t allocated in amqp_read_message
  -- *
  -- * \param [in] message
  -- *
  -- * \since v0.4.0
  --  

   procedure amqp_destroy_message (message : access amqp_message_t)  -- /usr/include/amqp.h:2196
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_destroy_message";

  --*
  -- * Envelope object
  -- *
  -- * \since v0.4.0
  --  

  --*< channel message was delivered on  
   type amqp_envelope_t_u is record
      channel : aliased amqp_channel_t;  -- /usr/include/amqp.h:2204
      consumer_tag : aliased amqp_bytes_t;  -- /usr/include/amqp.h:2205
      delivery_tag : aliased Unsigned_64;  -- /usr/include/amqp.h:2207
      redelivered : aliased amqp_boolean_t;  -- /usr/include/amqp.h:2208
      exchange : aliased amqp_bytes_t;  -- /usr/include/amqp.h:2210
      routing_key : aliased amqp_bytes_t;  -- /usr/include/amqp.h:2211
      message : aliased amqp_message_t;  -- /usr/include/amqp.h:2213
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp.h:2203

  --*< the consumer tag the message was delivered to
  --                                

  --*< the messages delivery tag  
  --*< flag indicating whether this message is being
  --                                 redelivered  

  --*< exchange this message was published to  
  --*< the routing key this message was published with
  --                              

  --*< the message  
   subtype amqp_envelope_t is amqp_envelope_t_u;  -- /usr/include/amqp.h:2214

  --*
  -- * Wait for and consume a message
  -- *
  -- * Waits for a basic.deliver method on any channel, upon receipt of
  -- * basic.deliver it reads that message, and returns. If any other method is
  -- * received before basic.deliver, this function will return an amqp_rpc_reply_t
  -- * with ret.reply_type == AMQP_RESPONSE_LIBRARY_EXCEPTION, and
  -- * ret.library_error == AMQP_STATUS_UNEXPECTED_STATE. The caller should then
  -- * call amqp_simple_wait_frame() to read this frame and take appropriate action.
  -- *
  -- * This function should be used after starting a consumer with the
  -- * amqp_basic_consume() function
  -- *
  -- * \param [in,out] state the connection object
  -- * \param [in,out] envelope a pointer to a amqp_envelope_t object. Caller
  -- *                 should call #amqp_destroy_envelope() when it is done using
  -- *                 the fields in the envelope object. The caller is responsible
  -- *                 for allocating/destroying the amqp_envelope_t object itself.
  -- * \param [in] timeout a timeout to wait for a message delivery. Passing in
  -- *             NULL will result in blocking behavior.
  -- * \param [in] flags pass in 0. Currently unused.
  -- * \returns a amqp_rpc_reply_t object.  ret.reply_type == AMQP_RESPONSE_NORMAL
  -- *          on success. If ret.reply_type == AMQP_RESPONSE_LIBRARY_EXCEPTION,
  -- *          and ret.library_error == AMQP_STATUS_UNEXPECTED_STATE, a frame other
  -- *          than AMQP_BASIC_DELIVER_METHOD was received, the caller should call
  -- *          amqp_simple_wait_frame() to read this frame and take appropriate
  -- *          action.
  -- *
  -- * \since v0.4.0
  --  

   function amqp_consume_message
     (state : amqp_connection_state_t;
      envelope : access amqp_envelope_t;
      timeout : access constant timeval;
      flags : int) return amqp_rpc_reply_t  -- /usr/include/amqp.h:2247
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_consume_message";

  --*
  -- * Frees memory associated with a amqp_envelope_t allocated in
  -- * amqp_consume_message()
  -- *
  -- * \param [in] envelope
  -- *
  -- * \since v0.4.0
  --  

   procedure amqp_destroy_envelope (envelope : access amqp_envelope_t)  -- /usr/include/amqp.h:2261
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_destroy_envelope";

  --*
  -- * Parameters used to connect to the RabbitMQ broker
  -- *
  -- * \since v0.2
  --  

  --*< the username to authenticate with the broker, default on most
  --                 broker is 'guest'  

   type amqp_connection_info is record
      user : Interfaces.C.Strings.chars_ptr;  -- /usr/include/amqp.h:2269
      password : Interfaces.C.Strings.chars_ptr;  -- /usr/include/amqp.h:2271
      host : Interfaces.C.Strings.chars_ptr;  -- /usr/include/amqp.h:2273
      vhost : Interfaces.C.Strings.chars_ptr;  -- /usr/include/amqp.h:2274
      port : aliased int;  -- /usr/include/amqp.h:2276
      ssl : aliased amqp_boolean_t;  -- /usr/include/amqp.h:2278
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp.h:2268

  --*< the password to authenticate with the broker, default on
  --                     most brokers is 'guest'  

  --*< the hostname of the broker  
  --*< the virtual host on the broker to connect to, a good default
  --                  is "/"  

  --*< the port that the broker is listening on, default on most
  --                  brokers is 5672  

  --*
  -- * Initialze an amqp_connection_info to default values
  -- *
  -- * The default values are:
  -- * - user: "guest"
  -- * - password: "guest"
  -- * - host: "localhost"
  -- * - vhost: "/"
  -- * - port: 5672
  -- *
  -- * \param [out] parsed the connection info to set defaults on
  -- *
  -- * \since v0.2
  --  

   procedure amqp_default_connection_info (parsed : access amqp_connection_info)  -- /usr/include/amqp.h:2297
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_default_connection_info";

  --*
  -- * Parse a connection URL
  -- *
  -- * An amqp connection url takes the form:
  -- *
  -- * amqp://[$USERNAME[:$PASSWORD]\@]$HOST[:$PORT]/[$VHOST]
  -- *
  -- * Examples:
  -- *  amqp://guest:guest\@localhost:5672//
  -- *  amqp://guest:guest\@localhost/myvhost
  -- *
  -- *  Any missing parts of the URL will be set to the defaults specified in
  -- *  amqp_default_connection_info. For amqps: URLs the default port will be set
  -- *  to 5671 instead of 5672 for non-SSL URLs.
  -- *
  -- * \note This function modifies url parameter.
  -- *
  -- * \param [in] url URI to parse, note that this parameter is modified by the
  -- *             function.
  -- * \param [out] parsed the connection info gleaned from the URI. The char*
  -- *              members will point to parts of the url input parameter.
  -- *              Memory management will depend on how the url is allocated.
  -- * \returns AMQP_STATUS_OK on success, AMQP_STATUS_BAD_URL on failure
  -- *
  -- * \since v0.2
  --  

   function amqp_parse_url (url : Interfaces.C.Strings.chars_ptr; parsed : access amqp_connection_info) return int  -- /usr/include/amqp.h:2326
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_parse_url";

  -- socket API  
  --*
  -- * Open a socket connection.
  -- *
  -- * This function opens a socket connection returned from amqp_tcp_socket_new()
  -- * or amqp_ssl_socket_new(). This function should be called after setting
  -- * socket options and prior to assigning the socket to an AMQP connection with
  -- * amqp_set_socket().
  -- *
  -- * \param [in,out] self A socket object.
  -- * \param [in] host Connect to this host.
  -- * \param [in] port Connect on this remote port.
  -- *
  -- * \return AMQP_STATUS_OK on success, an amqp_status_enum on failure
  -- *
  -- * \since v0.4.0
  --  

   function amqp_socket_open
     (self : access amqp_socket_t;
      host : Interfaces.C.Strings.chars_ptr;
      port : int) return int  -- /usr/include/amqp.h:2347
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_socket_open";

  --*
  -- * Open a socket connection.
  -- *
  -- * This function opens a socket connection returned from amqp_tcp_socket_new()
  -- * or amqp_ssl_socket_new(). This function should be called after setting
  -- * socket options and prior to assigning the socket to an AMQP connection with
  -- * amqp_set_socket().
  -- *
  -- * \param [in,out] self A socket object.
  -- * \param [in] host Connect to this host.
  -- * \param [in] port Connect on this remote port.
  -- * \param [in] timeout Max allowed time to spent on opening. If NULL - run in
  -- *             blocking mode
  -- *
  -- * \return AMQP_STATUS_OK on success, an amqp_status_enum on failure.
  -- *
  -- * \since v0.4.0
  --  

   function amqp_socket_open_noblock
     (self : access amqp_socket_t;
      host : Interfaces.C.Strings.chars_ptr;
      port : int;
      timeout : access constant timeval) return int  -- /usr/include/amqp.h:2368
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_socket_open_noblock";

  --*
  -- * Get the socket descriptor in use by a socket object.
  -- *
  -- * Retrieve the underlying socket descriptor. This function can be used to
  -- * perform low-level socket operations that aren't supported by the socket
  -- * interface. Use with caution!
  -- *
  -- * \param [in,out] self A socket object.
  -- *
  -- * \return The underlying socket descriptor, or -1 if there is no socket
  -- *  descriptor associated with
  -- *
  -- * \since v0.4.0
  --  

   function amqp_socket_get_sockfd (self : access amqp_socket_t) return int  -- /usr/include/amqp.h:2386
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_socket_get_sockfd";

  --*
  -- * Get the socket object associated with a amqp_connection_state_t
  -- *
  -- * \param [in] state the connection object to get the socket from
  -- * \return a pointer to the socket object, or NULL if one has not been assigned
  -- *
  -- * \since v0.4.0
  --  

   function amqp_get_socket (state : amqp_connection_state_t) return access amqp_socket_t  -- /usr/include/amqp.h:2397
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_get_socket";

  --*
  -- * Get the broker properties table
  -- *
  -- * \param [in] state the connection object
  -- * \return a pointer to an amqp_table_t containing the properties advertised
  -- *  by the broker on connection. The connection object owns the table, it
  -- *  should not be modified.
  -- *
  -- * \since v0.5.0
  --  

   function amqp_get_server_properties (state : amqp_connection_state_t) return access amqp_table_t  -- /usr/include/amqp.h:2411
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_get_server_properties";

  --*
  -- * Get the client properties table
  -- *
  -- * Get the properties that were passed to the broker on connection.
  -- *
  -- * \param [in] state the connection object
  -- * \return a pointer to an amqp_table_t containing the properties advertised
  -- *  by the client on connection. The connection object owns the table, it
  -- *  should not be modified.
  -- *
  -- * \since v0.7.0
  --  

   function amqp_get_client_properties (state : amqp_connection_state_t) return access amqp_table_t  -- /usr/include/amqp.h:2427
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_get_client_properties";

  --*
  -- * Get the login handshake timeout.
  -- *
  -- * amqp_login and amqp_login_with_properties perform the login handshake with
  -- * the broker.  This function returns the timeout associated with completing
  -- * this operation from the client side. This value can be set by using the
  -- * amqp_set_handshake_timeout.
  -- *
  -- * Note that the RabbitMQ broker has configurable timeout for completing the
  -- * login handshake, the default is 10 seconds.  rabbitmq-c has a default of 12
  -- * seconds.
  -- *
  -- * \param [in] state the connection object
  -- * \return a struct timeval representing the current login timeout for the state
  -- *  object. A NULL value represents an infinite timeout. The memory returned is
  -- *  owned by the connection object.
  -- *
  -- * \since v0.9.0
  --  

   function amqp_get_handshake_timeout (state : amqp_connection_state_t) return access timeval  -- /usr/include/amqp.h:2450
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_get_handshake_timeout";

  --*
  -- * Set the login handshake timeout.
  -- *
  -- * amqp_login and amqp_login_with_properties perform the login handshake with
  -- * the broker. This function sets the timeout associated with completing this
  -- * operation from the client side.
  -- *
  -- * The timeout must be set before amqp_login or amqp_login_with_properties is
  -- * called to change from the default timeout.
  -- *
  -- * Note that the RabbitMQ broker has a configurable timeout for completing the
  -- * login handshake, the default is 10 seconds. rabbitmq-c has a default of 12
  -- * seconds.
  -- *
  -- * \param [in] state the connection object
  -- * \param [in] timeout a struct timeval* representing new login timeout for the
  -- *  state object. NULL represents an infinite timeout. The value of timeout is
  -- *  copied internally, the caller is responsible for ownership of the passed in
  -- *  pointer, it does not need to remain valid after this function is called.
  -- * \return AMQP_STATUS_OK on success.
  -- *
  -- * \since v0.9.0
  --  

   function amqp_set_handshake_timeout (state : amqp_connection_state_t; timeout : access constant timeval) return int  -- /usr/include/amqp.h:2476
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_set_handshake_timeout";

  --*
  -- * Get the RPC timeout
  -- *
  -- * Gets the timeout for any RPC-style AMQP command (e.g., amqp_queue_declare).
  -- * This timeout may be changed at any time by calling \amqp_set_rpc_timeout
  -- * function with a new timeout. The timeout applies individually to each RPC
  -- * that is made.
  -- *
  -- * The default value is NULL, or an infinite timeout.
  -- *
  -- * When an RPC times out, the function will return an error AMQP_STATUS_TIMEOUT,
  -- * and the connection will be closed.
  -- *
  -- *\warning RPC-timeouts are an advanced feature intended to be used to detect
  -- * dead connections quickly when the rabbitmq-c implementation of heartbeats
  -- * does not work. Do not use RPC timeouts unless you understand the implications
  -- * of doing so.
  -- *
  -- * \param [in] state the connection object
  -- * \return a struct timeval representing the current RPC timeout for the state
  -- * object. A NULL value represents an infinite timeout. The memory returned is
  -- * owned by the connection object.
  -- *
  -- * \since v0.9.0
  --  

   function amqp_get_rpc_timeout (state : amqp_connection_state_t) return access timeval  -- /usr/include/amqp.h:2505
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_get_rpc_timeout";

  --*
  -- * Set the RPC timeout
  -- *
  -- * Sets the timeout for any RPC-style AMQP command (e.g., amqp_queue_declare).
  -- * This timeout may be changed at any time by calling this function with a new
  -- * timeout. The timeout applies individually to each RPC that is made.
  -- *
  -- * The default value is NULL, or an infinite timeout.
  -- *
  -- * When an RPC times out, the function will return an error AMQP_STATUS_TIMEOUT,
  -- * and the connection will be closed.
  -- *
  -- *\warning RPC-timeouts are an advanced feature intended to be used to detect
  -- * dead connections quickly when the rabbitmq-c implementation of heartbeats
  -- * does not work. Do not use RPC timeouts unless you understand the implications
  -- * of doing so.
  -- *
  -- * \param [in] state the connection object
  -- * \param [in] timeout a struct timeval* representing new RPC timeout for the
  -- * state object. NULL represents an infinite timeout. The value of timeout is
  -- * copied internally, the caller is responsible for ownership of the passed
  -- * pointer, it does not need to remain valid after this function is called.
  -- * \return AMQP_STATUS_SUCCESS on success.
  -- *
  -- * \since v0.9.0
  --  

   function amqp_set_rpc_timeout (state : amqp_connection_state_t; timeout : access constant timeval) return int  -- /usr/include/amqp.h:2534
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_set_rpc_timeout";


   --  ===========================================
   --  From amqp_framing.h (AMQP protocol types)
   --  ===========================================

AMQP_PROTOCOL_VERSION_MAJOR : constant := 0;  --  /usr/include/amqp_framing.h:45
   AMQP_PROTOCOL_VERSION_MINOR : constant := 9;  --  /usr/include/amqp_framing.h:46
   AMQP_PROTOCOL_VERSION_REVISION : constant := 1;  --  /usr/include/amqp_framing.h:47

   AMQP_PROTOCOL_PORT : constant := 5672;  --  /usr/include/amqp_framing.h:50
   AMQP_FRAME_METHOD : constant := 1;  --  /usr/include/amqp_framing.h:51
   AMQP_FRAME_HEADER : constant := 2;  --  /usr/include/amqp_framing.h:52
   AMQP_FRAME_BODY : constant := 3;  --  /usr/include/amqp_framing.h:53
   AMQP_FRAME_HEARTBEAT : constant := 8;  --  /usr/include/amqp_framing.h:54
   AMQP_FRAME_MIN_SIZE : constant := 4096;  --  /usr/include/amqp_framing.h:55
   AMQP_FRAME_END : constant := 206;  --  /usr/include/amqp_framing.h:56
   AMQP_REPLY_SUCCESS : constant := 200;  --  /usr/include/amqp_framing.h:57
   AMQP_CONTENT_TOO_LARGE : constant := 311;  --  /usr/include/amqp_framing.h:58
   AMQP_NO_ROUTE : constant := 312;  --  /usr/include/amqp_framing.h:59
   AMQP_NO_CONSUMERS : constant := 313;  --  /usr/include/amqp_framing.h:60
   AMQP_ACCESS_REFUSED : constant := 403;  --  /usr/include/amqp_framing.h:61
   AMQP_NOT_FOUND : constant := 404;  --  /usr/include/amqp_framing.h:62
   AMQP_RESOURCE_LOCKED : constant := 405;  --  /usr/include/amqp_framing.h:63
   AMQP_PRECONDITION_FAILED : constant := 406;  --  /usr/include/amqp_framing.h:64
   AMQP_CONNECTION_FORCED : constant := 320;  --  /usr/include/amqp_framing.h:65
   AMQP_INVALID_PATH : constant := 402;  --  /usr/include/amqp_framing.h:66
   AMQP_FRAME_ERROR : constant := 501;  --  /usr/include/amqp_framing.h:67
   AMQP_SYNTAX_ERROR : constant := 502;  --  /usr/include/amqp_framing.h:68
   AMQP_COMMAND_INVALID : constant := 503;  --  /usr/include/amqp_framing.h:69
   AMQP_CHANNEL_ERROR : constant := 504;  --  /usr/include/amqp_framing.h:70
   AMQP_UNEXPECTED_FRAME : constant := 505;  --  /usr/include/amqp_framing.h:71
   AMQP_RESOURCE_ERROR : constant := 506;  --  /usr/include/amqp_framing.h:72
   AMQP_NOT_ALLOWED : constant := 530;  --  /usr/include/amqp_framing.h:73
   AMQP_NOT_IMPLEMENTED : constant := 540;  --  /usr/include/amqp_framing.h:74
   AMQP_INTERNAL_ERROR : constant := 541;  --  /usr/include/amqp_framing.h:75
   --  unsupported macro: AMQP_CONNECTION_START_METHOD ((amqp_method_number_t)0x000A000A)
   --  unsupported macro: AMQP_CONNECTION_START_OK_METHOD ((amqp_method_number_t)0x000A000B)
   --  unsupported macro: AMQP_CONNECTION_SECURE_METHOD ((amqp_method_number_t)0x000A0014)
   --  unsupported macro: AMQP_CONNECTION_SECURE_OK_METHOD ((amqp_method_number_t)0x000A0015)
   --  unsupported macro: AMQP_CONNECTION_TUNE_METHOD ((amqp_method_number_t)0x000A001E)
   --  unsupported macro: AMQP_CONNECTION_TUNE_OK_METHOD ((amqp_method_number_t)0x000A001F)
   --  unsupported macro: AMQP_CONNECTION_OPEN_METHOD ((amqp_method_number_t)0x000A0028)
   --  unsupported macro: AMQP_CONNECTION_OPEN_OK_METHOD ((amqp_method_number_t)0x000A0029)
   --  unsupported macro: AMQP_CONNECTION_CLOSE_METHOD ((amqp_method_number_t)0x000A0032)
   --  unsupported macro: AMQP_CONNECTION_CLOSE_OK_METHOD ((amqp_method_number_t)0x000A0033)
   --  unsupported macro: AMQP_CONNECTION_BLOCKED_METHOD ((amqp_method_number_t)0x000A003C)
   --  unsupported macro: AMQP_CONNECTION_UNBLOCKED_METHOD ((amqp_method_number_t)0x000A003D)
   --  unsupported macro: AMQP_CHANNEL_OPEN_METHOD ((amqp_method_number_t)0x0014000A)
   --  unsupported macro: AMQP_CHANNEL_OPEN_OK_METHOD ((amqp_method_number_t)0x0014000B)
   --  unsupported macro: AMQP_CHANNEL_FLOW_METHOD ((amqp_method_number_t)0x00140014)
   --  unsupported macro: AMQP_CHANNEL_FLOW_OK_METHOD ((amqp_method_number_t)0x00140015)
   --  unsupported macro: AMQP_CHANNEL_CLOSE_METHOD ((amqp_method_number_t)0x00140028)
   --  unsupported macro: AMQP_CHANNEL_CLOSE_OK_METHOD ((amqp_method_number_t)0x00140029)
   --  unsupported macro: AMQP_ACCESS_REQUEST_METHOD ((amqp_method_number_t)0x001E000A)
   --  unsupported macro: AMQP_ACCESS_REQUEST_OK_METHOD ((amqp_method_number_t)0x001E000B)
   --  unsupported macro: AMQP_EXCHANGE_DECLARE_METHOD ((amqp_method_number_t)0x0028000A)
   --  unsupported macro: AMQP_EXCHANGE_DECLARE_OK_METHOD ((amqp_method_number_t)0x0028000B)
   --  unsupported macro: AMQP_EXCHANGE_DELETE_METHOD ((amqp_method_number_t)0x00280014)
   --  unsupported macro: AMQP_EXCHANGE_DELETE_OK_METHOD ((amqp_method_number_t)0x00280015)
   --  unsupported macro: AMQP_EXCHANGE_BIND_METHOD ((amqp_method_number_t)0x0028001E)
   --  unsupported macro: AMQP_EXCHANGE_BIND_OK_METHOD ((amqp_method_number_t)0x0028001F)
   --  unsupported macro: AMQP_EXCHANGE_UNBIND_METHOD ((amqp_method_number_t)0x00280028)
   --  unsupported macro: AMQP_EXCHANGE_UNBIND_OK_METHOD ((amqp_method_number_t)0x00280033)
   --  unsupported macro: AMQP_QUEUE_DECLARE_METHOD ((amqp_method_number_t)0x0032000A)
   --  unsupported macro: AMQP_QUEUE_DECLARE_OK_METHOD ((amqp_method_number_t)0x0032000B)
   --  unsupported macro: AMQP_QUEUE_BIND_METHOD ((amqp_method_number_t)0x00320014)
   --  unsupported macro: AMQP_QUEUE_BIND_OK_METHOD ((amqp_method_number_t)0x00320015)
   --  unsupported macro: AMQP_QUEUE_PURGE_METHOD ((amqp_method_number_t)0x0032001E)
   --  unsupported macro: AMQP_QUEUE_PURGE_OK_METHOD ((amqp_method_number_t)0x0032001F)
   --  unsupported macro: AMQP_QUEUE_DELETE_METHOD ((amqp_method_number_t)0x00320028)
   --  unsupported macro: AMQP_QUEUE_DELETE_OK_METHOD ((amqp_method_number_t)0x00320029)
   --  unsupported macro: AMQP_QUEUE_UNBIND_METHOD ((amqp_method_number_t)0x00320032)
   --  unsupported macro: AMQP_QUEUE_UNBIND_OK_METHOD ((amqp_method_number_t)0x00320033)
   --  unsupported macro: AMQP_BASIC_QOS_METHOD ((amqp_method_number_t)0x003C000A)
   --  unsupported macro: AMQP_BASIC_QOS_OK_METHOD ((amqp_method_number_t)0x003C000B)
   --  unsupported macro: AMQP_BASIC_CONSUME_METHOD ((amqp_method_number_t)0x003C0014)
   --  unsupported macro: AMQP_BASIC_CONSUME_OK_METHOD ((amqp_method_number_t)0x003C0015)
   --  unsupported macro: AMQP_BASIC_CANCEL_METHOD ((amqp_method_number_t)0x003C001E)
   --  unsupported macro: AMQP_BASIC_CANCEL_OK_METHOD ((amqp_method_number_t)0x003C001F)
   --  unsupported macro: AMQP_BASIC_PUBLISH_METHOD ((amqp_method_number_t)0x003C0028)
   --  unsupported macro: AMQP_BASIC_RETURN_METHOD ((amqp_method_number_t)0x003C0032)
   --  unsupported macro: AMQP_BASIC_DELIVER_METHOD ((amqp_method_number_t)0x003C003C)
   --  unsupported macro: AMQP_BASIC_GET_METHOD ((amqp_method_number_t)0x003C0046)
   --  unsupported macro: AMQP_BASIC_GET_OK_METHOD ((amqp_method_number_t)0x003C0047)
   --  unsupported macro: AMQP_BASIC_GET_EMPTY_METHOD ((amqp_method_number_t)0x003C0048)
   --  unsupported macro: AMQP_BASIC_ACK_METHOD ((amqp_method_number_t)0x003C0050)
   --  unsupported macro: AMQP_BASIC_REJECT_METHOD ((amqp_method_number_t)0x003C005A)
   --  unsupported macro: AMQP_BASIC_RECOVER_ASYNC_METHOD ((amqp_method_number_t)0x003C0064)
   --  unsupported macro: AMQP_BASIC_RECOVER_METHOD ((amqp_method_number_t)0x003C006E)
   --  unsupported macro: AMQP_BASIC_RECOVER_OK_METHOD ((amqp_method_number_t)0x003C006F)
   --  unsupported macro: AMQP_BASIC_NACK_METHOD ((amqp_method_number_t)0x003C0078)
   --  unsupported macro: AMQP_TX_SELECT_METHOD ((amqp_method_number_t)0x005A000A)
   --  unsupported macro: AMQP_TX_SELECT_OK_METHOD ((amqp_method_number_t)0x005A000B)
   --  unsupported macro: AMQP_TX_COMMIT_METHOD ((amqp_method_number_t)0x005A0014)
   --  unsupported macro: AMQP_TX_COMMIT_OK_METHOD ((amqp_method_number_t)0x005A0015)
   --  unsupported macro: AMQP_TX_ROLLBACK_METHOD ((amqp_method_number_t)0x005A001E)
   --  unsupported macro: AMQP_TX_ROLLBACK_OK_METHOD ((amqp_method_number_t)0x005A001F)
   --  unsupported macro: AMQP_CONFIRM_SELECT_METHOD ((amqp_method_number_t)0x0055000A)
   --  unsupported macro: AMQP_CONFIRM_SELECT_OK_METHOD ((amqp_method_number_t)0x0055000B)

   AMQP_CONNECTION_CLASS : constant := (16#000A#);  --  /usr/include/amqp_framing.h:795

   AMQP_CHANNEL_CLASS : constant := (16#0014#);  --  /usr/include/amqp_framing.h:804

   AMQP_ACCESS_CLASS : constant := (16#001E#);  --  /usr/include/amqp_framing.h:811

   AMQP_EXCHANGE_CLASS : constant := (16#0028#);  --  /usr/include/amqp_framing.h:818

   AMQP_QUEUE_CLASS : constant := (16#0032#);  --  /usr/include/amqp_framing.h:825

   AMQP_BASIC_CLASS : constant := (16#003C#);  --  /usr/include/amqp_framing.h:832
   AMQP_BASIC_CONTENT_TYPE_FLAG : constant := (2 ** 15);  --  /usr/include/amqp_framing.h:833
   AMQP_BASIC_CONTENT_ENCODING_FLAG : constant := (2 ** 14);  --  /usr/include/amqp_framing.h:834
   AMQP_BASIC_HEADERS_FLAG : constant := (2 ** 13);  --  /usr/include/amqp_framing.h:835
   AMQP_BASIC_DELIVERY_MODE_FLAG : constant := (2 ** 12);  --  /usr/include/amqp_framing.h:836
   AMQP_BASIC_PRIORITY_FLAG : constant := (2 ** 11);  --  /usr/include/amqp_framing.h:837
   AMQP_BASIC_CORRELATION_ID_FLAG : constant := (2 ** 10);  --  /usr/include/amqp_framing.h:838
   AMQP_BASIC_REPLY_TO_FLAG : constant := (2 ** 9);  --  /usr/include/amqp_framing.h:839
   AMQP_BASIC_EXPIRATION_FLAG : constant := (2 ** 8);  --  /usr/include/amqp_framing.h:840
   AMQP_BASIC_MESSAGE_ID_FLAG : constant := (2 ** 7);  --  /usr/include/amqp_framing.h:841
   AMQP_BASIC_TIMESTAMP_FLAG : constant := (2 ** 6);  --  /usr/include/amqp_framing.h:842
   AMQP_BASIC_TYPE_FLAG : constant := (2 ** 5);  --  /usr/include/amqp_framing.h:843
   AMQP_BASIC_USER_ID_FLAG : constant := (2 ** 4);  --  /usr/include/amqp_framing.h:844
   AMQP_BASIC_APP_ID_FLAG : constant := (2 ** 3);  --  /usr/include/amqp_framing.h:845
   AMQP_BASIC_CLUSTER_ID_FLAG : constant := (2 ** 2);  --  /usr/include/amqp_framing.h:846

   AMQP_TX_CLASS : constant := (16#005A#);  --  /usr/include/amqp_framing.h:866

   AMQP_CONFIRM_CLASS : constant := (16#0055#);  --  /usr/include/amqp_framing.h:873

  -- Generated code. Do not edit. Edit and re-run codegen.py instead.
  -- *
  -- * ***** BEGIN LICENSE BLOCK *****
  -- * Version: MIT
  -- *
  -- * Portions created by Alan Antonuk are Copyright (c) 2012-2013
  -- * Alan Antonuk. All Rights Reserved.
  -- *
  -- * Portions created by VMware are Copyright (c) 2007-2012 VMware, Inc.
  -- * All Rights Reserved.
  -- *
  -- * Portions created by Tony Garnock-Jones are Copyright (c) 2009-2010
  -- * VMware, Inc. and Tony Garnock-Jones. All Rights Reserved.
  -- *
  -- * Permission is hereby granted, free of charge, to any person
  -- * obtaining a copy of this software and associated documentation
  -- * files (the "Software"), to deal in the Software without
  -- * restriction, including without limitation the rights to use, copy,
  -- * modify, merge, publish, distribute, sublicense, and/or sell copies
  -- * of the Software, and to permit persons to whom the Software is
  -- * furnished to do so, subject to the following conditions:
  -- *
  -- * The above copyright notice and this permission notice shall be
  -- * included in all copies or substantial portions of the Software.
  -- *
  -- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
  -- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  -- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
  -- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
  -- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
  -- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
  -- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  -- * SOFTWARE.
  -- * ***** END LICENSE BLOCK *****
  --  

  --* @file amqp_framing.h  
  -- Function prototypes.  
  --*
  -- * Get constant name string from constant
  -- *
  -- * @param [in] constantNumber constant to get the name of
  -- * @returns string describing the constant. String is managed by
  -- *           the library and should not be free()'d by the program
  --  

   function amqp_constant_name (constantNumber : int) return Interfaces.C.Strings.chars_ptr  -- /usr/include/amqp_framing.h:87
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_constant_name";

  --*
  -- * Checks to see if a constant is a hard error
  -- *
  -- * A hard error occurs when something severe enough
  -- * happens that the connection must be closed.
  -- *
  -- * @param [in] constantNumber the error constant
  -- * @returns true if its a hard error, false otherwise
  --  

   function amqp_constant_is_hard_error (constantNumber : int) return amqp_boolean_t  -- /usr/include/amqp_framing.h:99
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_constant_is_hard_error";

  --*
  -- * Get method name string from method number
  -- *
  -- * @param [in] methodNumber the method number
  -- * @returns method name string. String is managed by the library
  -- *           and should not be freed()'d by the program
  --  

   function amqp_method_name (methodNumber : amqp_method_number_t) return Interfaces.C.Strings.chars_ptr  -- /usr/include/amqp_framing.h:109
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_method_name";

  --*
  -- * Check whether a method has content
  -- *
  -- * A method that has content will receive the method frame
  -- * a properties frame, then 1 to N body frames
  -- *
  -- * @param [in] methodNumber the method number
  -- * @returns true if method has content, false otherwise
  --  

   function amqp_method_has_content (methodNumber : amqp_method_number_t) return amqp_boolean_t  -- /usr/include/amqp_framing.h:122
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_method_has_content";

  --*
  -- * Decodes a method from AMQP wireformat
  -- *
  -- * @param [in] methodNumber the method number for the decoded parameter
  -- * @param [in] pool the memory pool to allocate the decoded method from
  -- * @param [in] encoded the encoded byte string buffer
  -- * @param [out] decoded pointer to the decoded method struct
  -- * @returns 0 on success, an error code otherwise
  --  

   function amqp_decode_method
     (methodNumber : amqp_method_number_t;
      pool : access amqp_pool_t_u;
      encoded : amqp_bytes_t;
      decoded : System.Address) return int  -- /usr/include/amqp_framing.h:134
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_decode_method";

  --*
  -- * Decodes a header frame properties structure from AMQP wireformat
  -- *
  -- * @param [in] class_id the class id for the decoded parameter
  -- * @param [in] pool the memory pool to allocate the decoded properties from
  -- * @param [in] encoded the encoded byte string buffer
  -- * @param [out] decoded pointer to the decoded properties struct
  -- * @returns 0 on success, an error code otherwise
  --  

   function amqp_decode_properties
     (class_id : Unsigned_16;
      pool : access amqp_pool_t_u;
      encoded : amqp_bytes_t;
      decoded : System.Address) return int  -- /usr/include/amqp_framing.h:148
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_decode_properties";

  --*
  -- * Encodes a method structure in AMQP wireformat
  -- *
  -- * @param [in] methodNumber the method number for the decoded parameter
  -- * @param [in] decoded the method structure (e.g., amqp_connection_start_t)
  -- * @param [in] encoded an allocated byte buffer for the encoded method
  -- *              structure to be written to. If the buffer isn't large enough
  -- *              to hold the encoded method, an error code will be returned.
  -- * @returns 0 on success, an error code otherwise.
  --  

   function amqp_encode_method
     (methodNumber : amqp_method_number_t;
      decoded : System.Address;
      encoded : amqp_bytes_t) return int  -- /usr/include/amqp_framing.h:162
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_encode_method";

  --*
  -- * Encodes a properties structure in AMQP wireformat
  -- *
  -- * @param [in] class_id the class id for the decoded parameter
  -- * @param [in] decoded the properties structure (e.g., amqp_basic_properties_t)
  -- * @param [in] encoded an allocated byte buffer for the encoded properties to
  -- * written to.
  -- *              If the buffer isn't large enough to hold the encoded method, an
  -- *              an error code will be returned
  -- * @returns 0 on success, an error code otherwise.
  --  

   function amqp_encode_properties
     (class_id : Unsigned_16;
      decoded : System.Address;
      encoded : amqp_bytes_t) return int  -- /usr/include/amqp_framing.h:177
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_encode_properties";

  -- Method field records.  
  --* connection.start method fields  
  --*< version-major  
   type amqp_connection_start_t_u is record
      version_major : aliased Unsigned_8;  -- /usr/include/amqp_framing.h:187
      version_minor : aliased Unsigned_8;  -- /usr/include/amqp_framing.h:188
      server_properties : aliased amqp_table_t;  -- /usr/include/amqp_framing.h:189
      mechanisms : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:190
      locales : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:191
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:186

  --*< version-minor  
  --*< server-properties  
  --*< mechanisms  
  --*< locales  
   subtype amqp_connection_start_t is amqp_connection_start_t_u;  -- /usr/include/amqp_framing.h:192

  --* connection.start-ok method fields  
  --*< client-properties  
   type amqp_connection_start_ok_t_u is record
      client_properties : aliased amqp_table_t;  -- /usr/include/amqp_framing.h:199
      mechanism : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:200
      response : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:201
      locale : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:202
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:198

  --*< mechanism  
  --*< response  
  --*< locale  
   subtype amqp_connection_start_ok_t is amqp_connection_start_ok_t_u;  -- /usr/include/amqp_framing.h:203

  --* connection.secure method fields  
  --*< challenge  
   type amqp_connection_secure_t_u is record
      challenge : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:210
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:209

   subtype amqp_connection_secure_t is amqp_connection_secure_t_u;  -- /usr/include/amqp_framing.h:211

  --* connection.secure-ok method fields  
  --*< response  
   type amqp_connection_secure_ok_t_u is record
      response : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:218
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:217

   subtype amqp_connection_secure_ok_t is amqp_connection_secure_ok_t_u;  -- /usr/include/amqp_framing.h:219

  --* connection.tune method fields  
  --*< channel-max  
   type amqp_connection_tune_t_u is record
      channel_max : aliased Unsigned_16;  -- /usr/include/amqp_framing.h:226
      frame_max : aliased Unsigned_32;  -- /usr/include/amqp_framing.h:227
      heartbeat : aliased Unsigned_16;  -- /usr/include/amqp_framing.h:228
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:225

  --*< frame-max  
  --*< heartbeat  
   subtype amqp_connection_tune_t is amqp_connection_tune_t_u;  -- /usr/include/amqp_framing.h:229

  --* connection.tune-ok method fields  
  --*< channel-max  
   type amqp_connection_tune_ok_t_u is record
      channel_max : aliased Unsigned_16;  -- /usr/include/amqp_framing.h:236
      frame_max : aliased Unsigned_32;  -- /usr/include/amqp_framing.h:237
      heartbeat : aliased Unsigned_16;  -- /usr/include/amqp_framing.h:238
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:235

  --*< frame-max  
  --*< heartbeat  
   subtype amqp_connection_tune_ok_t is amqp_connection_tune_ok_t_u;  -- /usr/include/amqp_framing.h:239

  --* connection.open method fields  
  --*< virtual-host  
   type amqp_connection_open_t_u is record
      virtual_host : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:246
      capabilities : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:247
      insist : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:248
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:245

  --*< capabilities  
  --*< insist  
   subtype amqp_connection_open_t is amqp_connection_open_t_u;  -- /usr/include/amqp_framing.h:249

  --* connection.open-ok method fields  
  --*< known-hosts  
   type amqp_connection_open_ok_t_u is record
      known_hosts : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:256
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:255

   subtype amqp_connection_open_ok_t is amqp_connection_open_ok_t_u;  -- /usr/include/amqp_framing.h:257

  --* connection.close method fields  
  --*< reply-code  
   type amqp_connection_close_t_u is record
      reply_code : aliased Unsigned_16;  -- /usr/include/amqp_framing.h:264
      reply_text : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:265
      class_id : aliased Unsigned_16;  -- /usr/include/amqp_framing.h:266
      method_id : aliased Unsigned_16;  -- /usr/include/amqp_framing.h:267
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:263

  --*< reply-text  
  --*< class-id  
  --*< method-id  
   subtype amqp_connection_close_t is amqp_connection_close_t_u;  -- /usr/include/amqp_framing.h:268

  --* connection.close-ok method fields  
  --*< Dummy field to avoid empty struct  
   type amqp_connection_close_ok_t_u is record
      dummy : aliased char;  -- /usr/include/amqp_framing.h:275
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:274

   subtype amqp_connection_close_ok_t is amqp_connection_close_ok_t_u;  -- /usr/include/amqp_framing.h:276

  --* connection.blocked method fields  
  --*< reason  
   type amqp_connection_blocked_t_u is record
      reason : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:283
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:282

   subtype amqp_connection_blocked_t is amqp_connection_blocked_t_u;  -- /usr/include/amqp_framing.h:284

  --* connection.unblocked method fields  
  --*< Dummy field to avoid empty struct  
   type amqp_connection_unblocked_t_u is record
      dummy : aliased char;  -- /usr/include/amqp_framing.h:291
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:290

   subtype amqp_connection_unblocked_t is amqp_connection_unblocked_t_u;  -- /usr/include/amqp_framing.h:292

  --* channel.open method fields  
  --*< out-of-band  
   type amqp_channel_open_t_u is record
      out_of_band : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:299
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:298

   subtype amqp_channel_open_t is amqp_channel_open_t_u;  -- /usr/include/amqp_framing.h:300

  --* channel.open-ok method fields  
  --*< channel-id  
   type amqp_channel_open_ok_t_u is record
      channel_id : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:307
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:306

   subtype amqp_channel_open_ok_t is amqp_channel_open_ok_t_u;  -- /usr/include/amqp_framing.h:308

  --* channel.flow method fields  
  --*< active  
   type amqp_channel_flow_t_u is record
      active : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:315
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:314

   subtype amqp_channel_flow_t is amqp_channel_flow_t_u;  -- /usr/include/amqp_framing.h:316

  --* channel.flow-ok method fields  
  --*< active  
   type amqp_channel_flow_ok_t_u is record
      active : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:323
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:322

   subtype amqp_channel_flow_ok_t is amqp_channel_flow_ok_t_u;  -- /usr/include/amqp_framing.h:324

  --* channel.close method fields  
  --*< reply-code  
   type amqp_channel_close_t_u is record
      reply_code : aliased Unsigned_16;  -- /usr/include/amqp_framing.h:331
      reply_text : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:332
      class_id : aliased Unsigned_16;  -- /usr/include/amqp_framing.h:333
      method_id : aliased Unsigned_16;  -- /usr/include/amqp_framing.h:334
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:330

  --*< reply-text  
  --*< class-id  
  --*< method-id  
   subtype amqp_channel_close_t is amqp_channel_close_t_u;  -- /usr/include/amqp_framing.h:335

  --* channel.close-ok method fields  
  --*< Dummy field to avoid empty struct  
   type amqp_channel_close_ok_t_u is record
      dummy : aliased char;  -- /usr/include/amqp_framing.h:342
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:341

   subtype amqp_channel_close_ok_t is amqp_channel_close_ok_t_u;  -- /usr/include/amqp_framing.h:343

  --* access.request method fields  
  --*< realm  
   type amqp_access_request_t_u is record
      realm : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:350
      exclusive : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:351
      passive : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:352
      active : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:353
      write : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:354
      read : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:355
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:349

  --*< exclusive  
  --*< passive  
  --*< active  
  --*< write  
  --*< read  
   subtype amqp_access_request_t is amqp_access_request_t_u;  -- /usr/include/amqp_framing.h:356

  --* access.request-ok method fields  
  --*< ticket  
   type amqp_access_request_ok_t_u is record
      ticket : aliased Unsigned_16;  -- /usr/include/amqp_framing.h:363
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:362

   subtype amqp_access_request_ok_t is amqp_access_request_ok_t_u;  -- /usr/include/amqp_framing.h:364

  --* exchange.declare method fields  
  --*< ticket  
   type amqp_exchange_declare_t_u is record
      ticket : aliased Unsigned_16;  -- /usr/include/amqp_framing.h:371
      exchange : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:372
      c_type : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:373
      passive : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:374
      durable : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:375
      auto_delete : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:376
      internal : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:377
      nowait : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:378
      arguments : aliased amqp_table_t;  -- /usr/include/amqp_framing.h:379
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:370

  --*< exchange  
  --*< type  
  --*< passive  
  --*< durable  
  --*< auto-delete  
  --*< internal  
  --*< nowait  
  --*< arguments  
   subtype amqp_exchange_declare_t is amqp_exchange_declare_t_u;  -- /usr/include/amqp_framing.h:380

  --* exchange.declare-ok method fields  
  --*< Dummy field to avoid empty struct  
   type amqp_exchange_declare_ok_t_u is record
      dummy : aliased char;  -- /usr/include/amqp_framing.h:387
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:386

   subtype amqp_exchange_declare_ok_t is amqp_exchange_declare_ok_t_u;  -- /usr/include/amqp_framing.h:388

  --* exchange.delete method fields  
  --*< ticket  
   type amqp_exchange_delete_t_u is record
      ticket : aliased Unsigned_16;  -- /usr/include/amqp_framing.h:395
      exchange : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:396
      if_unused : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:397
      nowait : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:398
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:394

  --*< exchange  
  --*< if-unused  
  --*< nowait  
   subtype amqp_exchange_delete_t is amqp_exchange_delete_t_u;  -- /usr/include/amqp_framing.h:399

  --* exchange.delete-ok method fields  
  --*< Dummy field to avoid empty struct  
   type amqp_exchange_delete_ok_t_u is record
      dummy : aliased char;  -- /usr/include/amqp_framing.h:406
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:405

   subtype amqp_exchange_delete_ok_t is amqp_exchange_delete_ok_t_u;  -- /usr/include/amqp_framing.h:407

  --* exchange.bind method fields  
  --*< ticket  
   type amqp_exchange_bind_t_u is record
      ticket : aliased Unsigned_16;  -- /usr/include/amqp_framing.h:414
      destination : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:415
      source : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:416
      routing_key : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:417
      nowait : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:418
      arguments : aliased amqp_table_t;  -- /usr/include/amqp_framing.h:419
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:413

  --*< destination  
  --*< source  
  --*< routing-key  
  --*< nowait  
  --*< arguments  
   subtype amqp_exchange_bind_t is amqp_exchange_bind_t_u;  -- /usr/include/amqp_framing.h:420

  --* exchange.bind-ok method fields  
  --*< Dummy field to avoid empty struct  
   type amqp_exchange_bind_ok_t_u is record
      dummy : aliased char;  -- /usr/include/amqp_framing.h:427
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:426

   subtype amqp_exchange_bind_ok_t is amqp_exchange_bind_ok_t_u;  -- /usr/include/amqp_framing.h:428

  --* exchange.unbind method fields  
  --*< ticket  
   type amqp_exchange_unbind_t_u is record
      ticket : aliased Unsigned_16;  -- /usr/include/amqp_framing.h:435
      destination : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:436
      source : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:437
      routing_key : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:438
      nowait : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:439
      arguments : aliased amqp_table_t;  -- /usr/include/amqp_framing.h:440
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:434

  --*< destination  
  --*< source  
  --*< routing-key  
  --*< nowait  
  --*< arguments  
   subtype amqp_exchange_unbind_t is amqp_exchange_unbind_t_u;  -- /usr/include/amqp_framing.h:441

  --* exchange.unbind-ok method fields  
  --*< Dummy field to avoid empty struct  
   type amqp_exchange_unbind_ok_t_u is record
      dummy : aliased char;  -- /usr/include/amqp_framing.h:448
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:447

   subtype amqp_exchange_unbind_ok_t is amqp_exchange_unbind_ok_t_u;  -- /usr/include/amqp_framing.h:449

  --* queue.declare method fields  
  --*< ticket  
   type amqp_queue_declare_t_u is record
      ticket : aliased Unsigned_16;  -- /usr/include/amqp_framing.h:456
      queue : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:457
      passive : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:458
      durable : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:459
      exclusive : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:460
      auto_delete : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:461
      nowait : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:462
      arguments : aliased amqp_table_t;  -- /usr/include/amqp_framing.h:463
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:455

  --*< queue  
  --*< passive  
  --*< durable  
  --*< exclusive  
  --*< auto-delete  
  --*< nowait  
  --*< arguments  
   subtype amqp_queue_declare_t is amqp_queue_declare_t_u;  -- /usr/include/amqp_framing.h:464

  --* queue.declare-ok method fields  
  --*< queue  
   type amqp_queue_declare_ok_t_u is record
      queue : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:471
      message_count : aliased Unsigned_32;  -- /usr/include/amqp_framing.h:472
      consumer_count : aliased Unsigned_32;  -- /usr/include/amqp_framing.h:473
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:470

  --*< message-count  
  --*< consumer-count  
   subtype amqp_queue_declare_ok_t is amqp_queue_declare_ok_t_u;  -- /usr/include/amqp_framing.h:474

  --* queue.bind method fields  
  --*< ticket  
   type amqp_queue_bind_t_u is record
      ticket : aliased Unsigned_16;  -- /usr/include/amqp_framing.h:481
      queue : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:482
      exchange : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:483
      routing_key : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:484
      nowait : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:485
      arguments : aliased amqp_table_t;  -- /usr/include/amqp_framing.h:486
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:480

  --*< queue  
  --*< exchange  
  --*< routing-key  
  --*< nowait  
  --*< arguments  
   subtype amqp_queue_bind_t is amqp_queue_bind_t_u;  -- /usr/include/amqp_framing.h:487

  --* queue.bind-ok method fields  
  --*< Dummy field to avoid empty struct  
   type amqp_queue_bind_ok_t_u is record
      dummy : aliased char;  -- /usr/include/amqp_framing.h:494
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:493

   subtype amqp_queue_bind_ok_t is amqp_queue_bind_ok_t_u;  -- /usr/include/amqp_framing.h:495

  --* queue.purge method fields  
  --*< ticket  
   type amqp_queue_purge_t_u is record
      ticket : aliased Unsigned_16;  -- /usr/include/amqp_framing.h:502
      queue : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:503
      nowait : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:504
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:501

  --*< queue  
  --*< nowait  
   subtype amqp_queue_purge_t is amqp_queue_purge_t_u;  -- /usr/include/amqp_framing.h:505

  --* queue.purge-ok method fields  
  --*< message-count  
   type amqp_queue_purge_ok_t_u is record
      message_count : aliased Unsigned_32;  -- /usr/include/amqp_framing.h:512
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:511

   subtype amqp_queue_purge_ok_t is amqp_queue_purge_ok_t_u;  -- /usr/include/amqp_framing.h:513

  --* queue.delete method fields  
  --*< ticket  
   type amqp_queue_delete_t_u is record
      ticket : aliased Unsigned_16;  -- /usr/include/amqp_framing.h:520
      queue : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:521
      if_unused : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:522
      if_empty : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:523
      nowait : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:524
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:519

  --*< queue  
  --*< if-unused  
  --*< if-empty  
  --*< nowait  
   subtype amqp_queue_delete_t is amqp_queue_delete_t_u;  -- /usr/include/amqp_framing.h:525

  --* queue.delete-ok method fields  
  --*< message-count  
   type amqp_queue_delete_ok_t_u is record
      message_count : aliased Unsigned_32;  -- /usr/include/amqp_framing.h:532
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:531

   subtype amqp_queue_delete_ok_t is amqp_queue_delete_ok_t_u;  -- /usr/include/amqp_framing.h:533

  --* queue.unbind method fields  
  --*< ticket  
   type amqp_queue_unbind_t_u is record
      ticket : aliased Unsigned_16;  -- /usr/include/amqp_framing.h:540
      queue : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:541
      exchange : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:542
      routing_key : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:543
      arguments : aliased amqp_table_t;  -- /usr/include/amqp_framing.h:544
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:539

  --*< queue  
  --*< exchange  
  --*< routing-key  
  --*< arguments  
   subtype amqp_queue_unbind_t is amqp_queue_unbind_t_u;  -- /usr/include/amqp_framing.h:545

  --* queue.unbind-ok method fields  
  --*< Dummy field to avoid empty struct  
   type amqp_queue_unbind_ok_t_u is record
      dummy : aliased char;  -- /usr/include/amqp_framing.h:552
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:551

   subtype amqp_queue_unbind_ok_t is amqp_queue_unbind_ok_t_u;  -- /usr/include/amqp_framing.h:553

  --* basic.qos method fields  
  --*< prefetch-size  
   type amqp_basic_qos_t_u is record
      prefetch_size : aliased Unsigned_32;  -- /usr/include/amqp_framing.h:560
      prefetch_count : aliased Unsigned_16;  -- /usr/include/amqp_framing.h:561
      global : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:562
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:559

  --*< prefetch-count  
  --*< global  
   subtype amqp_basic_qos_t is amqp_basic_qos_t_u;  -- /usr/include/amqp_framing.h:563

  --* basic.qos-ok method fields  
  --*< Dummy field to avoid empty struct  
   type amqp_basic_qos_ok_t_u is record
      dummy : aliased char;  -- /usr/include/amqp_framing.h:570
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:569

   subtype amqp_basic_qos_ok_t is amqp_basic_qos_ok_t_u;  -- /usr/include/amqp_framing.h:571

  --* basic.consume method fields  
  --*< ticket  
   type amqp_basic_consume_t_u is record
      ticket : aliased Unsigned_16;  -- /usr/include/amqp_framing.h:578
      queue : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:579
      consumer_tag : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:580
      no_local : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:581
      no_ack : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:582
      exclusive : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:583
      nowait : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:584
      arguments : aliased amqp_table_t;  -- /usr/include/amqp_framing.h:585
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:577

  --*< queue  
  --*< consumer-tag  
  --*< no-local  
  --*< no-ack  
  --*< exclusive  
  --*< nowait  
  --*< arguments  
   subtype amqp_basic_consume_t is amqp_basic_consume_t_u;  -- /usr/include/amqp_framing.h:586

  --* basic.consume-ok method fields  
  --*< consumer-tag  
   type amqp_basic_consume_ok_t_u is record
      consumer_tag : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:593
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:592

   subtype amqp_basic_consume_ok_t is amqp_basic_consume_ok_t_u;  -- /usr/include/amqp_framing.h:594

  --* basic.cancel method fields  
  --*< consumer-tag  
   type amqp_basic_cancel_t_u is record
      consumer_tag : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:601
      nowait : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:602
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:600

  --*< nowait  
   subtype amqp_basic_cancel_t is amqp_basic_cancel_t_u;  -- /usr/include/amqp_framing.h:603

  --* basic.cancel-ok method fields  
  --*< consumer-tag  
   type amqp_basic_cancel_ok_t_u is record
      consumer_tag : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:610
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:609

   subtype amqp_basic_cancel_ok_t is amqp_basic_cancel_ok_t_u;  -- /usr/include/amqp_framing.h:611

  --* basic.publish method fields  
  --*< ticket  
   type amqp_basic_publish_t_u is record
      ticket : aliased Unsigned_16;  -- /usr/include/amqp_framing.h:618
      exchange : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:619
      routing_key : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:620
      mandatory : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:621
      immediate : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:622
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:617

  --*< exchange  
  --*< routing-key  
  --*< mandatory  
  --*< immediate  
   subtype amqp_basic_publish_t is amqp_basic_publish_t_u;  -- /usr/include/amqp_framing.h:623

  --* basic.return method fields  
  --*< reply-code  
   type amqp_basic_return_t_u is record
      reply_code : aliased Unsigned_16;  -- /usr/include/amqp_framing.h:630
      reply_text : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:631
      exchange : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:632
      routing_key : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:633
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:629

  --*< reply-text  
  --*< exchange  
  --*< routing-key  
   subtype amqp_basic_return_t is amqp_basic_return_t_u;  -- /usr/include/amqp_framing.h:634

  --* basic.deliver method fields  
  --*< consumer-tag  
   type amqp_basic_deliver_t_u is record
      consumer_tag : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:641
      delivery_tag : aliased Unsigned_64;  -- /usr/include/amqp_framing.h:642
      redelivered : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:643
      exchange : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:644
      routing_key : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:645
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:640

  --*< delivery-tag  
  --*< redelivered  
  --*< exchange  
  --*< routing-key  
   subtype amqp_basic_deliver_t is amqp_basic_deliver_t_u;  -- /usr/include/amqp_framing.h:646

  --* basic.get method fields  
  --*< ticket  
   type amqp_basic_get_t_u is record
      ticket : aliased Unsigned_16;  -- /usr/include/amqp_framing.h:653
      queue : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:654
      no_ack : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:655
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:652

  --*< queue  
  --*< no-ack  
   subtype amqp_basic_get_t is amqp_basic_get_t_u;  -- /usr/include/amqp_framing.h:656

  --* basic.get-ok method fields  
  --*< delivery-tag  
   type amqp_basic_get_ok_t_u is record
      delivery_tag : aliased Unsigned_64;  -- /usr/include/amqp_framing.h:663
      redelivered : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:664
      exchange : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:665
      routing_key : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:666
      message_count : aliased Unsigned_32;  -- /usr/include/amqp_framing.h:667
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:662

  --*< redelivered  
  --*< exchange  
  --*< routing-key  
  --*< message-count  
   subtype amqp_basic_get_ok_t is amqp_basic_get_ok_t_u;  -- /usr/include/amqp_framing.h:668

  --* basic.get-empty method fields  
  --*< cluster-id  
   type amqp_basic_get_empty_t_u is record
      cluster_id : aliased amqp_bytes_t;  -- /usr/include/amqp_framing.h:675
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:674

   subtype amqp_basic_get_empty_t is amqp_basic_get_empty_t_u;  -- /usr/include/amqp_framing.h:676

  --* basic.ack method fields  
  --*< delivery-tag  
   type amqp_basic_ack_t_u is record
      delivery_tag : aliased Unsigned_64;  -- /usr/include/amqp_framing.h:683
      multiple : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:684
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:682

  --*< multiple  
   subtype amqp_basic_ack_t is amqp_basic_ack_t_u;  -- /usr/include/amqp_framing.h:685

  --* basic.reject method fields  
  --*< delivery-tag  
   type amqp_basic_reject_t_u is record
      delivery_tag : aliased Unsigned_64;  -- /usr/include/amqp_framing.h:692
      c_requeue : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:693
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:691

  --*< requeue  
   subtype amqp_basic_reject_t is amqp_basic_reject_t_u;  -- /usr/include/amqp_framing.h:694

  --* basic.recover-async method fields  
  --*< requeue  
   type amqp_basic_recover_async_t_u is record
      c_requeue : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:701
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:700

   subtype amqp_basic_recover_async_t is amqp_basic_recover_async_t_u;  -- /usr/include/amqp_framing.h:702

  --* basic.recover method fields  
  --*< requeue  
   type amqp_basic_recover_t_u is record
      c_requeue : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:709
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:708

   subtype amqp_basic_recover_t is amqp_basic_recover_t_u;  -- /usr/include/amqp_framing.h:710

  --* basic.recover-ok method fields  
  --*< Dummy field to avoid empty struct  
   type amqp_basic_recover_ok_t_u is record
      dummy : aliased char;  -- /usr/include/amqp_framing.h:717
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:716

   subtype amqp_basic_recover_ok_t is amqp_basic_recover_ok_t_u;  -- /usr/include/amqp_framing.h:718

  --* basic.nack method fields  
  --*< delivery-tag  
   type amqp_basic_nack_t_u is record
      delivery_tag : aliased Unsigned_64;  -- /usr/include/amqp_framing.h:725
      multiple : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:726
      c_requeue : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:727
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:724

  --*< multiple  
  --*< requeue  
   subtype amqp_basic_nack_t is amqp_basic_nack_t_u;  -- /usr/include/amqp_framing.h:728

  --* tx.select method fields  
  --*< Dummy field to avoid empty struct  
   type amqp_tx_select_t_u is record
      dummy : aliased char;  -- /usr/include/amqp_framing.h:735
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:734

   subtype amqp_tx_select_t is amqp_tx_select_t_u;  -- /usr/include/amqp_framing.h:736

  --* tx.select-ok method fields  
  --*< Dummy field to avoid empty struct  
   type amqp_tx_select_ok_t_u is record
      dummy : aliased char;  -- /usr/include/amqp_framing.h:743
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:742

   subtype amqp_tx_select_ok_t is amqp_tx_select_ok_t_u;  -- /usr/include/amqp_framing.h:744

  --* tx.commit method fields  
  --*< Dummy field to avoid empty struct  
   type amqp_tx_commit_t_u is record
      dummy : aliased char;  -- /usr/include/amqp_framing.h:751
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:750

   subtype amqp_tx_commit_t is amqp_tx_commit_t_u;  -- /usr/include/amqp_framing.h:752

  --* tx.commit-ok method fields  
  --*< Dummy field to avoid empty struct  
   type amqp_tx_commit_ok_t_u is record
      dummy : aliased char;  -- /usr/include/amqp_framing.h:759
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:758

   subtype amqp_tx_commit_ok_t is amqp_tx_commit_ok_t_u;  -- /usr/include/amqp_framing.h:760

  --* tx.rollback method fields  
  --*< Dummy field to avoid empty struct  
   type amqp_tx_rollback_t_u is record
      dummy : aliased char;  -- /usr/include/amqp_framing.h:767
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:766

   subtype amqp_tx_rollback_t is amqp_tx_rollback_t_u;  -- /usr/include/amqp_framing.h:768

  --* tx.rollback-ok method fields  
  --*< Dummy field to avoid empty struct  
   type amqp_tx_rollback_ok_t_u is record
      dummy : aliased char;  -- /usr/include/amqp_framing.h:775
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:774

   subtype amqp_tx_rollback_ok_t is amqp_tx_rollback_ok_t_u;  -- /usr/include/amqp_framing.h:776

  --* confirm.select method fields  
  --*< nowait  
   type amqp_confirm_select_t_u is record
      nowait : aliased amqp_boolean_t;  -- /usr/include/amqp_framing.h:783
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:782

   subtype amqp_confirm_select_t is amqp_confirm_select_t_u;  -- /usr/include/amqp_framing.h:784

  --* confirm.select-ok method fields  
  --*< Dummy field to avoid empty struct  
   type amqp_confirm_select_ok_t_u is record
      dummy : aliased char;  -- /usr/include/amqp_framing.h:791
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:790

   subtype amqp_confirm_select_ok_t is amqp_confirm_select_ok_t_u;  -- /usr/include/amqp_framing.h:792

  -- Class property records.  
  --* connection class properties  
  --*< bit-mask of set fields  
   type amqp_connection_properties_t_u is record
      u_flags : aliased amqp_flags_t;  -- /usr/include/amqp_framing.h:800
      dummy : aliased char;  -- /usr/include/amqp_framing.h:801
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:799

  --*< Dummy field to avoid empty struct  
   subtype amqp_connection_properties_t is amqp_connection_properties_t_u;  -- /usr/include/amqp_framing.h:802

  --* channel class properties  
  --*< bit-mask of set fields  
   type amqp_channel_properties_t_u is record
      u_flags : aliased amqp_flags_t;  -- /usr/include/amqp_framing.h:807
      dummy : aliased char;  -- /usr/include/amqp_framing.h:808
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:806

  --*< Dummy field to avoid empty struct  
   subtype amqp_channel_properties_t is amqp_channel_properties_t_u;  -- /usr/include/amqp_framing.h:809

  --* access class properties  
  --*< bit-mask of set fields  
   type amqp_access_properties_t_u is record
      u_flags : aliased amqp_flags_t;  -- /usr/include/amqp_framing.h:814
      dummy : aliased char;  -- /usr/include/amqp_framing.h:815
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:813

  --*< Dummy field to avoid empty struct  
   subtype amqp_access_properties_t is amqp_access_properties_t_u;  -- /usr/include/amqp_framing.h:816

  --* exchange class properties  
  --*< bit-mask of set fields  
   type amqp_exchange_properties_t_u is record
      u_flags : aliased amqp_flags_t;  -- /usr/include/amqp_framing.h:821
      dummy : aliased char;  -- /usr/include/amqp_framing.h:822
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:820

  --*< Dummy field to avoid empty struct  
   subtype amqp_exchange_properties_t is amqp_exchange_properties_t_u;  -- /usr/include/amqp_framing.h:823

  --* queue class properties  
  --*< bit-mask of set fields  
   type amqp_queue_properties_t_u is record
      u_flags : aliased amqp_flags_t;  -- /usr/include/amqp_framing.h:828
      dummy : aliased char;  -- /usr/include/amqp_framing.h:829
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:827

  --*< Dummy field to avoid empty struct
   subtype amqp_queue_properties_t is amqp_queue_properties_t_u;  -- /usr/include/amqp_framing.h:830

  --  NOTE: amqp_basic_properties_t_u moved earlier in file to resolve circular dependency

  --* tx class properties  
  --*< bit-mask of set fields  
   type amqp_tx_properties_t_u is record
      u_flags : aliased amqp_flags_t;  -- /usr/include/amqp_framing.h:869
      dummy : aliased char;  -- /usr/include/amqp_framing.h:870
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:868

  --*< Dummy field to avoid empty struct  
   subtype amqp_tx_properties_t is amqp_tx_properties_t_u;  -- /usr/include/amqp_framing.h:871

  --* confirm class properties  
  --*< bit-mask of set fields  
   type amqp_confirm_properties_t_u is record
      u_flags : aliased amqp_flags_t;  -- /usr/include/amqp_framing.h:876
      dummy : aliased char;  -- /usr/include/amqp_framing.h:877
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/amqp_framing.h:875

  --*< Dummy field to avoid empty struct  
   subtype amqp_confirm_properties_t is amqp_confirm_properties_t_u;  -- /usr/include/amqp_framing.h:878

  -- API functions for methods  
  --*
  -- * amqp_channel_open
  -- *
  -- * @param [in] state connection state
  -- * @param [in] channel the channel to do the RPC on
  -- * @returns amqp_channel_open_ok_t
  --  

   function amqp_channel_open (state : amqp_connection_state_t; channel : amqp_channel_t) return access amqp_channel_open_ok_t  -- /usr/include/amqp_framing.h:891
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_channel_open";

  --*
  -- * amqp_channel_flow
  -- *
  -- * @param [in] state connection state
  -- * @param [in] channel the channel to do the RPC on
  -- * @param [in] active active
  -- * @returns amqp_channel_flow_ok_t
  --  

   function amqp_channel_flow
     (state : amqp_connection_state_t;
      channel : amqp_channel_t;
      active : amqp_boolean_t) return access amqp_channel_flow_ok_t  -- /usr/include/amqp_framing.h:902
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_channel_flow";

  --*
  -- * amqp_exchange_declare
  -- *
  -- * @param [in] state connection state
  -- * @param [in] channel the channel to do the RPC on
  -- * @param [in] exchange exchange
  -- * @param [in] type type
  -- * @param [in] passive passive
  -- * @param [in] durable durable
  -- * @param [in] auto_delete auto_delete
  -- * @param [in] internal internal
  -- * @param [in] arguments arguments
  -- * @returns amqp_exchange_declare_ok_t
  --  

   function amqp_exchange_declare
     (state : amqp_connection_state_t;
      channel : amqp_channel_t;
      exchange : amqp_bytes_t;
      c_type : amqp_bytes_t;
      passive : amqp_boolean_t;
      durable : amqp_boolean_t;
      auto_delete : amqp_boolean_t;
      internal : amqp_boolean_t;
      arguments : amqp_table_t) return access amqp_exchange_declare_ok_t  -- /usr/include/amqp_framing.h:919
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_exchange_declare";

  --*
  -- * amqp_exchange_delete
  -- *
  -- * @param [in] state connection state
  -- * @param [in] channel the channel to do the RPC on
  -- * @param [in] exchange exchange
  -- * @param [in] if_unused if_unused
  -- * @returns amqp_exchange_delete_ok_t
  --  

   function amqp_exchange_delete
     (state : amqp_connection_state_t;
      channel : amqp_channel_t;
      exchange : amqp_bytes_t;
      if_unused : amqp_boolean_t) return access amqp_exchange_delete_ok_t  -- /usr/include/amqp_framing.h:935
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_exchange_delete";

  --*
  -- * amqp_exchange_bind
  -- *
  -- * @param [in] state connection state
  -- * @param [in] channel the channel to do the RPC on
  -- * @param [in] destination destination
  -- * @param [in] source source
  -- * @param [in] routing_key routing_key
  -- * @param [in] arguments arguments
  -- * @returns amqp_exchange_bind_ok_t
  --  

   function amqp_exchange_bind
     (state : amqp_connection_state_t;
      channel : amqp_channel_t;
      destination : amqp_bytes_t;
      source : amqp_bytes_t;
      routing_key : amqp_bytes_t;
      arguments : amqp_table_t) return access amqp_exchange_bind_ok_t  -- /usr/include/amqp_framing.h:950
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_exchange_bind";

  --*
  -- * amqp_exchange_unbind
  -- *
  -- * @param [in] state connection state
  -- * @param [in] channel the channel to do the RPC on
  -- * @param [in] destination destination
  -- * @param [in] source source
  -- * @param [in] routing_key routing_key
  -- * @param [in] arguments arguments
  -- * @returns amqp_exchange_unbind_ok_t
  --  

   function amqp_exchange_unbind
     (state : amqp_connection_state_t;
      channel : amqp_channel_t;
      destination : amqp_bytes_t;
      source : amqp_bytes_t;
      routing_key : amqp_bytes_t;
      arguments : amqp_table_t) return access amqp_exchange_unbind_ok_t  -- /usr/include/amqp_framing.h:966
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_exchange_unbind";

  --*
  -- * amqp_queue_declare
  -- *
  -- * @param [in] state connection state
  -- * @param [in] channel the channel to do the RPC on
  -- * @param [in] queue queue
  -- * @param [in] passive passive
  -- * @param [in] durable durable
  -- * @param [in] exclusive exclusive
  -- * @param [in] auto_delete auto_delete
  -- * @param [in] arguments arguments
  -- * @returns amqp_queue_declare_ok_t
  --  

   function amqp_queue_declare
     (state : amqp_connection_state_t;
      channel : amqp_channel_t;
      queue : amqp_bytes_t;
      passive : amqp_boolean_t;
      durable : amqp_boolean_t;
      exclusive : amqp_boolean_t;
      auto_delete : amqp_boolean_t;
      arguments : amqp_table_t) return access amqp_queue_declare_ok_t  -- /usr/include/amqp_framing.h:983
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_queue_declare";

  --*
  -- * amqp_queue_bind
  -- *
  -- * @param [in] state connection state
  -- * @param [in] channel the channel to do the RPC on
  -- * @param [in] queue queue
  -- * @param [in] exchange exchange
  -- * @param [in] routing_key routing_key
  -- * @param [in] arguments arguments
  -- * @returns amqp_queue_bind_ok_t
  --  

   function amqp_queue_bind
     (state : amqp_connection_state_t;
      channel : amqp_channel_t;
      queue : amqp_bytes_t;
      exchange : amqp_bytes_t;
      routing_key : amqp_bytes_t;
      arguments : amqp_table_t) return access amqp_queue_bind_ok_t  -- /usr/include/amqp_framing.h:999
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_queue_bind";

  --*
  -- * amqp_queue_purge
  -- *
  -- * @param [in] state connection state
  -- * @param [in] channel the channel to do the RPC on
  -- * @param [in] queue queue
  -- * @returns amqp_queue_purge_ok_t
  --  

   function amqp_queue_purge
     (state : amqp_connection_state_t;
      channel : amqp_channel_t;
      queue : amqp_bytes_t) return access amqp_queue_purge_ok_t  -- /usr/include/amqp_framing.h:1011
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_queue_purge";

  --*
  -- * amqp_queue_delete
  -- *
  -- * @param [in] state connection state
  -- * @param [in] channel the channel to do the RPC on
  -- * @param [in] queue queue
  -- * @param [in] if_unused if_unused
  -- * @param [in] if_empty if_empty
  -- * @returns amqp_queue_delete_ok_t
  --  

   function amqp_queue_delete
     (state : amqp_connection_state_t;
      channel : amqp_channel_t;
      queue : amqp_bytes_t;
      if_unused : amqp_boolean_t;
      if_empty : amqp_boolean_t) return access amqp_queue_delete_ok_t  -- /usr/include/amqp_framing.h:1025
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_queue_delete";

  --*
  -- * amqp_queue_unbind
  -- *
  -- * @param [in] state connection state
  -- * @param [in] channel the channel to do the RPC on
  -- * @param [in] queue queue
  -- * @param [in] exchange exchange
  -- * @param [in] routing_key routing_key
  -- * @param [in] arguments arguments
  -- * @returns amqp_queue_unbind_ok_t
  --  

   function amqp_queue_unbind
     (state : amqp_connection_state_t;
      channel : amqp_channel_t;
      queue : amqp_bytes_t;
      exchange : amqp_bytes_t;
      routing_key : amqp_bytes_t;
      arguments : amqp_table_t) return access amqp_queue_unbind_ok_t  -- /usr/include/amqp_framing.h:1040
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_queue_unbind";

  --*
  -- * amqp_basic_qos
  -- *
  -- * @param [in] state connection state
  -- * @param [in] channel the channel to do the RPC on
  -- * @param [in] prefetch_size prefetch_size
  -- * @param [in] prefetch_count prefetch_count
  -- * @param [in] global global
  -- * @returns amqp_basic_qos_ok_t
  --  

   function amqp_basic_qos
     (state : amqp_connection_state_t;
      channel : amqp_channel_t;
      prefetch_size : Unsigned_32;
      prefetch_count : Unsigned_16;
      global : amqp_boolean_t) return access amqp_basic_qos_ok_t  -- /usr/include/amqp_framing.h:1054
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_basic_qos";

  --*
  -- * amqp_basic_consume
  -- *
  -- * @param [in] state connection state
  -- * @param [in] channel the channel to do the RPC on
  -- * @param [in] queue queue
  -- * @param [in] consumer_tag consumer_tag
  -- * @param [in] no_local no_local
  -- * @param [in] no_ack no_ack
  -- * @param [in] exclusive exclusive
  -- * @param [in] arguments arguments
  -- * @returns amqp_basic_consume_ok_t
  --  

   function amqp_basic_consume
     (state : amqp_connection_state_t;
      channel : amqp_channel_t;
      queue : amqp_bytes_t;
      consumer_tag : amqp_bytes_t;
      no_local : amqp_boolean_t;
      no_ack : amqp_boolean_t;
      exclusive : amqp_boolean_t;
      arguments : amqp_table_t) return access amqp_basic_consume_ok_t  -- /usr/include/amqp_framing.h:1073
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_basic_consume";

  --*
  -- * amqp_basic_cancel
  -- *
  -- * @param [in] state connection state
  -- * @param [in] channel the channel to do the RPC on
  -- * @param [in] consumer_tag consumer_tag
  -- * @returns amqp_basic_cancel_ok_t
  --  

   function amqp_basic_cancel
     (state : amqp_connection_state_t;
      channel : amqp_channel_t;
      consumer_tag : amqp_bytes_t) return access amqp_basic_cancel_ok_t  -- /usr/include/amqp_framing.h:1087
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_basic_cancel";

  --*
  -- * amqp_basic_recover
  -- *
  -- * @param [in] state connection state
  -- * @param [in] channel the channel to do the RPC on
  -- * @param [in] requeue requeue
  -- * @returns amqp_basic_recover_ok_t
  --  

   function amqp_basic_recover
     (state : amqp_connection_state_t;
      channel : amqp_channel_t;
      c_requeue : amqp_boolean_t) return access amqp_basic_recover_ok_t  -- /usr/include/amqp_framing.h:1099
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_basic_recover";

  --*
  -- * amqp_tx_select
  -- *
  -- * @param [in] state connection state
  -- * @param [in] channel the channel to do the RPC on
  -- * @returns amqp_tx_select_ok_t
  --  

   function amqp_tx_select (state : amqp_connection_state_t; channel : amqp_channel_t) return access amqp_tx_select_ok_t  -- /usr/include/amqp_framing.h:1109
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_tx_select";

  --*
  -- * amqp_tx_commit
  -- *
  -- * @param [in] state connection state
  -- * @param [in] channel the channel to do the RPC on
  -- * @returns amqp_tx_commit_ok_t
  --  

   function amqp_tx_commit (state : amqp_connection_state_t; channel : amqp_channel_t) return access amqp_tx_commit_ok_t  -- /usr/include/amqp_framing.h:1119
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_tx_commit";

  --*
  -- * amqp_tx_rollback
  -- *
  -- * @param [in] state connection state
  -- * @param [in] channel the channel to do the RPC on
  -- * @returns amqp_tx_rollback_ok_t
  --  

   function amqp_tx_rollback (state : amqp_connection_state_t; channel : amqp_channel_t) return access amqp_tx_rollback_ok_t  -- /usr/include/amqp_framing.h:1129
   with Import => True, 
        Convention => C, 
        External_Name => "amqp_tx_rollback";

  --*
  -- * amqp_confirm_select
  -- *
  -- * @param [in] state connection state
  -- * @param [in] channel the channel to do the RPC on
  -- * @returns amqp_confirm_select_ok_t
  --  

   function amqp_confirm_select (state : amqp_connection_state_t; channel : amqp_channel_t) return access amqp_confirm_select_ok_t  -- /usr/include/amqp_framing.h:1140
   with Import => True,
        Convention => C,
        External_Name => "amqp_confirm_select";

   --  ===========================================
   --  From amqp_tcp_socket.h (TCP socket support)
   --  ===========================================

   --  Create a new TCP socket.
   --  Call amqp_connection_close() to release socket resources.
   --  Returns a new socket object or NULL if an error occurred.
   function amqp_tcp_socket_new (state : amqp_connection_state_t) return access amqp_socket_t_u
   with Import => True,
        Convention => C,
        External_Name => "amqp_tcp_socket_new";

   --  Assign an open file descriptor to a socket object.
   --  This function must not be used in conjunction with amqp_socket_open().
   procedure amqp_tcp_socket_set_sockfd
     (self : access amqp_socket_t_u; sockfd : int)
   with Import => True,
        Convention => C,
        External_Name => "amqp_tcp_socket_set_sockfd";

   --  ===========================================
   --  Ada helper wrappers (from rabbitmq_ada_helpers.c)
   --  ===========================================

   --  Non-variadic wrapper for amqp_login with PLAIN authentication
   function rabbitmq_ada_login_plain
     (state       : amqp_connection_state_t;
      vhost       : Interfaces.C.Strings.chars_ptr;
      channel_max : int;
      frame_max   : int;
      heartbeat   : int;
      username    : Interfaces.C.Strings.chars_ptr;
      password    : Interfaces.C.Strings.chars_ptr) return amqp_rpc_reply_t
   with Import => True,
        Convention => C,
        External_Name => "rabbitmq_ada_login_plain";

   --  ===========================================
   --  SSL/TLS Socket Functions (from amqp_ssl_socket.h)
   --  ===========================================

   --  TLS version constants
   AMQP_TLSv1      : constant := 1;
   AMQP_TLSv1_1    : constant := 2;
   AMQP_TLSv1_2    : constant := 3;
   AMQP_TLSvLATEST : constant := 65535;

   subtype amqp_tls_version_t is Interfaces.C.unsigned;

   --  Create a new SSL/TLS socket object
   function amqp_ssl_socket_new
     (state : amqp_connection_state_t) return access amqp_socket_t_u
   with Import => True,
        Convention => C,
        External_Name => "amqp_ssl_socket_new";

   --  Set the CA certificate
   function amqp_ssl_socket_set_cacert
     (self   : access amqp_socket_t_u;
      cacert : Interfaces.C.Strings.chars_ptr) return int
   with Import => True,
        Convention => C,
        External_Name => "amqp_ssl_socket_set_cacert";

   --  Set the password for key in PEM format
   procedure amqp_ssl_socket_set_key_passwd
     (self   : access amqp_socket_t_u;
      passwd : Interfaces.C.Strings.chars_ptr)
   with Import => True,
        Convention => C,
        External_Name => "amqp_ssl_socket_set_key_passwd";

   --  Set the client certificate and key
   function amqp_ssl_socket_set_key
     (self : access amqp_socket_t_u;
      cert : Interfaces.C.Strings.chars_ptr;
      key  : Interfaces.C.Strings.chars_ptr) return int
   with Import => True,
        Convention => C,
        External_Name => "amqp_ssl_socket_set_key";

   --  Enable or disable peer verification (deprecated, use set_verify_peer)
   procedure amqp_ssl_socket_set_verify
     (self   : access amqp_socket_t_u;
      verify : amqp_boolean_t)
   with Import => True,
        Convention => C,
        External_Name => "amqp_ssl_socket_set_verify";

   --  Enable or disable peer certificate verification
   procedure amqp_ssl_socket_set_verify_peer
     (self   : access amqp_socket_t_u;
      verify : amqp_boolean_t)
   with Import => True,
        Convention => C,
        External_Name => "amqp_ssl_socket_set_verify_peer";

   --  Enable or disable hostname verification
   procedure amqp_ssl_socket_set_verify_hostname
     (self   : access amqp_socket_t_u;
      verify : amqp_boolean_t)
   with Import => True,
        Convention => C,
        External_Name => "amqp_ssl_socket_set_verify_hostname";

   --  Set min and max TLS versions
   function amqp_ssl_socket_set_ssl_versions
     (self : access amqp_socket_t_u;
      min  : amqp_tls_version_t;
      max  : amqp_tls_version_t) return int
   with Import => True,
        Convention => C,
        External_Name => "amqp_ssl_socket_set_ssl_versions";

   --  Control whether rabbitmq-c initializes the SSL library
   procedure amqp_set_initialize_ssl_library
     (do_initialize : amqp_boolean_t)
   with Import => True,
        Convention => C,
        External_Name => "amqp_set_initialize_ssl_library";

   --  Initialize the underlying SSL/TLS library
   function amqp_initialize_ssl_library return int
   with Import => True,
        Convention => C,
        External_Name => "amqp_initialize_ssl_library";

   --  Uninitialize the underlying SSL/TLS library
   function amqp_uninitialize_ssl_library return int
   with Import => True,
        Convention => C,
        External_Name => "amqp_uninitialize_ssl_library";

end RabbitMQ.C_Binding;
