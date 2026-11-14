import { Octokit } from 'octokit';

export type Project = {
	name: string;
	description: string;
	url: string;
	createdAt: string;
	forkCount: number;
	stargazerCount: number;
};

export async function getProjects(): Promise<Project[]> {
	const token = import.meta.env.GITHUB_TOKEN;
	if (!token) {
		throw new Error('GITHUB_TOKEN is not set');
	}

	const octokit = new Octokit({ auth: token });

	const projects = (await octokit.graphql(`
		query {
			user(login: "IcyTv") {
				pinnedItems(first: 6, types: REPOSITORY) {
					nodes {
						... on Repository {
							name
							description
							url
							createdAt
							forkCount
							stargazerCount
						}
					}
				}
			}
		}
	`)) as {
		user: {
			pinnedItems: {
				nodes: Project[];
			};
		};
	};

	console.log('Projects', JSON.stringify(projects, null, 2));

	return projects.user.pinnedItems.nodes;
}
