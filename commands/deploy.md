Deploy the current project to Vercel.

Steps:
1. Run `git status` to check for uncommitted changes — warn the user if any exist
2. Check if `vercel` CLI is logged in: `vercel whoami`
3. If not logged in, prompt: "Run `vercel login` in your terminal first"
4. Check for `vercel.json` in the project root — create a basic one if missing
5. Run `vercel --prod` to deploy to production
6. Output the deployment URL

Pre-flight checks:
- Confirm environment variables are set in Vercel dashboard (remind user)
- Check that build script exists in package.json
- Verify the framework is detected correctly

After deploy: show the live URL and suggest running `vercel env ls` to verify env vars.
