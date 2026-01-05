ALTER TABLE "files" RENAME COLUMN "path" TO "relative_path";--> statement-breakpoint
ALTER TABLE "files" ADD COLUMN "thumbnail_path" varchar(1000);--> statement-breakpoint
ALTER TABLE "files" ADD COLUMN "original_name" varchar(255) NOT NULL;