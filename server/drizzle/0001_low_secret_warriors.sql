CREATE TABLE "files" (
	"id" varchar(255) PRIMARY KEY NOT NULL,
	"uploader_id" varchar(255) NOT NULL,
	"parent_id" varchar(255) NOT NULL,
	"bucket" varchar(100) NOT NULL,
	"path" varchar(1000) NOT NULL,
	"size"  double precision NOT NULL,
	"mime_type" varchar(255) NOT NULL,
	"ext" varchar(50) NOT NULL,
	"width"  double precision,
	"height"  double precision,
	"duration" double precision,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"deleted" boolean DEFAULT false NOT NULL
);
--> statement-breakpoint
ALTER TABLE "files" ADD CONSTRAINT "files_uploader_id_users_id_fk" FOREIGN KEY ("uploader_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;